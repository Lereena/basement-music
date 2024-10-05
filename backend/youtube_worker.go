package main

import (
	"log"
	"net/http"
	"net/url"
	"os"
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
	log.Println(fetchedInfo.Fulltitle)
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Couldn't fetch video info: url = "+uri)
	}

	splitSymbolsRegexp := regexp.MustCompile(splitSymbols)
	titleSplit := splitSymbolsRegexp.Split(fetchedInfo.Fulltitle, -1)
	log.Println(titleSplit)

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
	log.Print(trackFileName)

	tempFilePath := filepath.Join(yw.Cfg.MusicPath, "track"+uuid.NewString()+".mp3")
	youtubeDl := goydl.NewYoutubeDl()
	youtubeDl.Options.Output.Value = tempFilePath
	youtubeDl.Options.ExtractAudio.Value = true
	youtubeDl.Options.AudioFormat.Value = "mp3"

	cmd, err := youtubeDl.Download(url)
	if err != nil {
		log.Print("Couldn't download: ", err)
		return
	}

	cmd.Wait()

	permanentFilePath := filepath.Join(yw.Cfg.MusicPath, trackFileName)
	err = os.Rename(tempFilePath, permanentFilePath)
	if err != nil {
		log.Print("Couldn't rename track file: ", err)
		return
	}

	trackId := yw.musicRepo.CreateTrack(artist, title, int(youtubeDl.Info.Duration), trackFileName, "")
	if err != nil {
		log.Print("Couldn't create track in db: ", err)
		return
	}

	// Extract artist names from the track's artist field
	artistNames := strings.Split(artist, ",")

	// Create artist-track entries in the database
	for _, artistName := range artistNames {
		name := strings.TrimSpace(artistName)
		artistId := yw.artistsRepo.CreateArtist(name)

		err := yw.artistsRepo.AssociateTrackWithArtist(artistId, trackId)

		if err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}

}
