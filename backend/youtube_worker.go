package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/repositories"
	"github.com/TheKinrar/goydl"
	"github.com/google/uuid"
)

type YoutubeWorker struct {
	musicRepo *repositories.TracksRepository
	Cfg       *config.Config
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

	yw.musicRepo.CreateTrack(artist, title, int(youtubeDl.Info.Duration), trackFileName, "")
	if err != nil {
		log.Print("Couldn't create track in db: ", err)
		return
	}

	return
}
