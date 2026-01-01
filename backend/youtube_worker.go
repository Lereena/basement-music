package main

import (
	"bytes"
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
	"github.com/TheKinrar/goydl"
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

func (yw *YoutubeWorker) FetchVideoInfo(w http.ResponseWriter, r *http.Request) {
	uri := r.FormValue("url")

	youtubeDl := goydl.NewYoutubeDl()
	youtubeDl.VideoURL = uri

	fetchedInfo, err := youtubeDl.GetInfo()
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Couldn't fetch video info: url = "+uri)
		return
	}

	splitSymbolsRegexp := regexp.MustCompile(splitSymbols)
	titleSplit := splitSymbolsRegexp.Split(fetchedInfo.Fulltitle, -1)

	var title, artist string

	if len(titleSplit) == 1 {
		title = titleSplit[0]
		artist = fetchedInfo.Uploader
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

	// Get video info to get duration
	youtubeDl := goydl.NewYoutubeDl()
	youtubeDl.VideoURL = url
	fetchedInfo, err := youtubeDl.GetInfo()
	if err != nil {
		log.Printf("Couldn't fetch video info: %v", err)
		respond.RespondError(w, http.StatusInternalServerError, "Couldn't fetch video info")
		return
	}

	// Find yt-dlp binary
	ytDlpPath := "/usr/bin/yt-dlp"
	if _, err := os.Stat(ytDlpPath); os.IsNotExist(err) {
		ytDlpPath = "/usr/local/bin/youtube-dl"
	}
	cmd := exec.Command(ytDlpPath,
		"-f", "bestaudio/best",
		"-x",
		"--audio-format", "mp3",
		"--audio-quality", "0",
		"-o", tempFilePathNoExt+".%(ext)s",
		"--no-warnings",
		"--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
		"--extractor-args", "youtube:player_client=android",
		"--retries", "3",
		url,
	)

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err = cmd.Run()
	if err != nil {
		errorMsg := stderr.String()
		if errorMsg == "" {
			errorMsg = stdout.String()
		}
		if errorMsg == "" {
			errorMsg = err.Error()
		}
		log.Printf("Download failed: %v - %s", err, errorMsg)
		respond.RespondError(w, http.StatusInternalServerError, "Download failed: "+errorMsg)
		return
	}

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

	trackId := yw.musicRepo.CreateTrack(artist, title, int(fetchedInfo.Duration), trackFileName, "")
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
