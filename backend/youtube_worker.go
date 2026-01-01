package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/repositories"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
)

type YoutubeWorker struct {
	musicRepo   *repositories.TracksRepository
	artistsRepo *repositories.ArtistsRepository
	Cfg         *config.Config
}

type VideoInfo struct {
	Artist string `json:"artist"`
	Title  string `json:"title"`
}

type videoData struct {
	Title    string  `json:"title"`
	Uploader string  `json:"uploader"`
	Duration float64 `json:"duration"`
}

func findYtDlpPath() string {
	ytDlpPath := "/usr/bin/yt-dlp"
	if _, err := os.Stat(ytDlpPath); os.IsNotExist(err) {
		ytDlpPath = "/usr/local/bin/youtube-dl"
	}
	return ytDlpPath
}

func buildYtDlpBaseArgs() []string {
	return []string{
		"--no-warnings",
		"--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
		"--extractor-args", "youtube:player_client=android",
		"--retries", "3",
	}
}

func runYtDlpCommand(ytDlpPath string, args []string) ([]byte, []byte, error) {
	cmd := exec.Command(ytDlpPath, args...)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	return stdout.Bytes(), stderr.Bytes(), err
}

func extractErrorMessage(stderr, stdout []byte, err error) string {
	if errorMsg := string(stderr); errorMsg != "" {
		return errorMsg
	}
	if errorMsg := string(stdout); errorMsg != "" {
		return errorMsg
	}
	if err != nil {
		return err.Error()
	}
	return "unknown error"
}

func getVideoInfo(ytDlpPath, videoURL string) (*videoData, []byte, error) {
	args := append([]string{"--dump-json"}, buildYtDlpBaseArgs()...)
	args = append(args, videoURL)

	stdout, stderr, err := runYtDlpCommand(ytDlpPath, args)
	if err != nil {
		return nil, stderr, err
	}

	var videoData videoData
	if err := json.Unmarshal(stdout, &videoData); err != nil {
		return nil, stderr, err
	}

	return &videoData, stderr, nil
}

func (yw *YoutubeWorker) FetchVideoInfo(w http.ResponseWriter, r *http.Request) {
	uri := r.FormValue("url")

	ytDlpPath := findYtDlpPath()
	videoData, stderr, err := getVideoInfo(ytDlpPath, uri)
	if err != nil {
		errorMsg := extractErrorMessage(stderr, nil, err)
		log.Printf("Failed to fetch video info: %v - %s", err, errorMsg)
		respond.RespondError(w, http.StatusNotFound, "Couldn't fetch video info: "+errorMsg)
		return
	}

	splitSymbolsRegexp := regexp.MustCompile(splitSymbols)
	titleSplit := splitSymbolsRegexp.Split(videoData.Title, -1)

	var title, artist string

	if len(titleSplit) == 1 {
		title = titleSplit[0]
		artist = videoData.Uploader
	}
	if len(titleSplit) >= 2 {
		artist = titleSplit[0]
		title = titleSplit[1]
	}

	videoInfo := VideoInfo{Artist: url.QueryEscape(strings.Trim(artist, " ")), Title: url.QueryEscape(strings.Trim(title, " "))}

	respond.RespondJSON(w, http.StatusOK, videoInfo)
}

func (yw *YoutubeWorker) FetchFromYoutube(w http.ResponseWriter, r *http.Request) {
	url := r.FormValue("url")
	artist := r.FormValue("artist")
	title := r.FormValue("title")

	trackFileName := artist + " - " + title + ".mp3"

	// Ensure the music directory exists
	if err := os.MkdirAll(yw.Cfg.MusicPath, 0755); err != nil {
		log.Printf("Couldn't create music directory: %v", err)
		respond.RespondError(w, http.StatusInternalServerError, "Couldn't create music directory")
		return
	}

	tempFileBase := "track" + uuid.NewString()
	tempFilePathNoExt := filepath.Join(yw.Cfg.MusicPath, tempFileBase)

	ytDlpPath := findYtDlpPath()

	// Get video info to get duration
	videoData, stderr, err := getVideoInfo(ytDlpPath, url)
	if err != nil {
		errorMsg := extractErrorMessage(stderr, nil, err)
		log.Printf("Couldn't fetch video info: %v - %s", err, errorMsg)
		respond.RespondError(w, http.StatusInternalServerError, "Couldn't fetch video info: "+errorMsg)
		return
	}

	// Download audio
	downloadArgs := append([]string{
		"-f", "bestaudio/best",
		"-x",
		"--audio-format", "mp3",
		"--audio-quality", "0",
		"-o", tempFilePathNoExt + ".%(ext)s",
	}, buildYtDlpBaseArgs()...)
	downloadArgs = append(downloadArgs, url)

	stdout, stderr, err := runYtDlpCommand(ytDlpPath, downloadArgs)
	if err != nil {
		errorMsg := extractErrorMessage(stderr, stdout, err)
		log.Printf("Download failed: %v - %s", err, errorMsg)
		respond.RespondError(w, http.StatusInternalServerError, "Download failed: "+errorMsg)
		return
	}
	_ = stdout // Suppress unused variable warning

	// Verify the downloaded file exists (should be .mp3 after conversion)
	tempFilePath := tempFilePathNoExt + ".mp3"
	if _, err := os.Stat(tempFilePath); os.IsNotExist(err) {
		log.Printf("Downloaded file not found at: %s", tempFilePath)
		respond.RespondError(w, http.StatusInternalServerError, "Downloaded file not found")
		return
	}

	permanentFilePath := filepath.Join(yw.Cfg.MusicPath, trackFileName)
	err = os.Rename(tempFilePath, permanentFilePath)
	if err != nil {
		log.Printf("Couldn't rename track file from %s to %s: %v", tempFilePath, permanentFilePath, err)
		respond.RespondError(w, http.StatusInternalServerError, "Couldn't rename track file")
		return
	}

	trackId := yw.musicRepo.CreateTrack(artist, title, int(videoData.Duration), trackFileName, "")
	if err != nil {
		log.Printf("Couldn't create track in db: %v", err)
		respond.RespondError(w, http.StatusInternalServerError, "Couldn't create track in database")
		return
	}

	// Create and associate artists
	artistNames := strings.Split(artist, ",")
	for _, artistName := range artistNames {
		name := strings.TrimSpace(artistName)
		artistId := yw.artistsRepo.CreateArtist(name)
		if err := yw.artistsRepo.AssociateTrackWithArtist(artistId, trackId); err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}

	respond.RespondJSON(w, http.StatusOK, map[string]interface{}{
		"message": "Track downloaded successfully",
		"trackId": trackId,
	})
}
