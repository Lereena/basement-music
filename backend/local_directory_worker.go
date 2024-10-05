package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/repositories"
)

type LocalDirectoryWorker struct {
	musicRepo   *repositories.TracksRepository
	artistsRepo *repositories.ArtistsRepository
	Cfg         *config.Config
}

func (ldw *LocalDirectoryWorker) ScanMusicDirectory() {
	files, err := ioutil.ReadDir(ldw.Cfg.MusicPath)
	log.Printf("File Path = %s", ldw.Cfg.MusicPath)

	if err != nil {
		log.Printf("Couldn't read music directory content: %v", err)
		return
	}

	err = ldw.artistsRepo.DB.Exec("DELETE FROM artist_tracks").Error
	if err != nil {
		log.Printf("Error clearing artist_tracks table: %v", err)
	}
	err = ldw.musicRepo.DB.Exec("DELETE FROM artists").Error
	if err != nil {
		log.Printf("Error clearing artists table: %v", err)
	}

	for _, f := range files {
		result := ldw.musicRepo.DB.Where("Url = ?", f.Name()).Limit(1).Find(&models.Track{})
		if result.RowsAffected == 0 {
			ldw.saveTrack(f.Name())
		}

		track := models.Track{}
		ldw.musicRepo.DB.Where("Url = ?", f.Name()).First(&track)
		ldw.handleArtists(track.Artist, track.Id)
	}
}

func (ldw *LocalDirectoryWorker) UploadFile(w http.ResponseWriter, r *http.Request) {
	err := r.ParseMultipartForm(32 << 20)
	if err != nil {
		http.Error(w, "Error parsing form: "+err.Error(), http.StatusBadRequest)
		return
	}

	files := r.MultipartForm.File["files"]

	for _, file := range files {
		src, err := file.Open()
		if err != nil {
			http.Error(w, "Error opening file: "+err.Error(), http.StatusInternalServerError)
			return
		}
		defer src.Close()

		name := "music/" + file.Filename
		fmt.Printf("File name %s\n", name)

		out, err := os.Create(name)
		if err != nil {
			http.Error(w, "Error creating destination file: "+err.Error(), http.StatusInternalServerError)
			return
		}
		defer out.Close()

		_, err = io.Copy(out, src)
		if err != nil {
			http.Error(w, "Error copying file: "+err.Error(), http.StatusInternalServerError)
			return
		}

		ldw.saveTrack(file.Filename)
	}
}

func (ldw *LocalDirectoryWorker) saveTrack(filename string) {
	splitSymbolsRegexp := regexp.MustCompile(splitSymbols)

	titleSplit := splitSymbolsRegexp.Split(filename, -1)

	if len(titleSplit) == 1 {
		log.Printf("Title '%s' has no split symbols, skipping", filename)
		return
	}

	fmt.Println(filename)
	artists, title := strings.TrimSpace(titleSplit[0]), strings.TrimSpace(titleSplit[1])

	index := strings.LastIndex(title, ".")
	if index > -1 {
		title = title[:index]
	}

	duration := ldw.Cfg.GetTrackDuration(filename)
	trackId := ldw.musicRepo.CreateTrack(artists, title, duration, filename, "")

	ldw.handleArtists(artists, trackId)
}

func (ldw *LocalDirectoryWorker) handleArtists(artists string, trackId string) {
	// Extract artist names from the track's artist field
	artistNames := strings.Split(artists, ",")

	// Create artist-track entries in the database
	for _, artistName := range artistNames {
		name := strings.TrimSpace(artistName)
		artistId := ldw.artistsRepo.CreateArtist(name)

		err := ldw.artistsRepo.AssociateTrackWithArtist(artistId, trackId)

		if err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}
}
