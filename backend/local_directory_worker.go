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
	musicRepo *repositories.TracksRepository
	Cfg       *config.Config
}

func (ldw *LocalDirectoryWorker) ScanMusicDirectory() {
	files, err := ioutil.ReadDir(ldw.Cfg.MusicPath)
	log.Printf("File Path = %s", ldw.Cfg.MusicPath)

	if err != nil {
		log.Printf("Couldn't read music directory content: %v", err)
		return
	}

	for _, f := range files {
		result := ldw.musicRepo.DB.Where("Url = ?", f.Name()).Limit(1).Find(&models.Track{})
		if result.RowsAffected != 0 {
			continue
		}

		ldw.saveTrack(f.Name())
	}
}

func (ldw *LocalDirectoryWorker) UploadFile(w http.ResponseWriter, r *http.Request) {
	r.ParseMultipartForm(32 << 20)

	file, header, err := r.FormFile("file")
	if err != nil {
		fmt.Println("Error uploading file", err)
		return
	}
	defer file.Close()

	name := "music/" + header.Filename
	fmt.Printf("File name %s\n", name)

	out, err := os.Create(name)
	if err != nil {
		fmt.Print("Unable to create file for writing", err)
		return
	}
	defer out.Close()

	_, err = io.Copy(out, file)
	if err != nil {
		fmt.Println("Error writing to file", err)
		return
	}
	fmt.Println("file uploaded successfully")

	ldw.saveTrack(header.Filename)
}

func (ldw *LocalDirectoryWorker) saveTrack(filename string) {
	splitSymbols := regexp.MustCompile("[−‐‑-ー一-]")

	titleSplit := splitSymbols.Split(filename, -1)

	if len(titleSplit) == 1 {
		log.Printf("Title '%s' has no split symbols, skipping", filename)
		return
	}

	fmt.Println(filename)
	artist, title := strings.TrimSpace(titleSplit[0]), strings.TrimSpace(titleSplit[1])

	index := strings.LastIndex(title, ".")
	if index > -1 {
		title = title[:index]
	}

	duration := ldw.Cfg.GetTrackDuration(filename)
	ldw.musicRepo.CreateTrack(artist, title, duration, filename, "")
}
