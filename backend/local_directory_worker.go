package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/bogem/id3v2/v2"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/repositories"
)

type LocalDirectoryWorker struct {
	musicRepo   *repositories.TracksRepository
	artistsRepo *repositories.ArtistsRepository
	albumsRepo  *repositories.AlbumsRepository
	Cfg         *config.Config
}

func (ldw *LocalDirectoryWorker) ScanMusicDirectory() {
	files, err := ioutil.ReadDir(ldw.Cfg.MusicPath)
	log.Printf("File Path = %s", ldw.Cfg.MusicPath)

	if err != nil {
		log.Printf("Couldn't read music directory content: %v", err)
		return
	}

	// Rebuild of artist_tracks is idempotent (CreateArtist is find-or-create).
	// Artists themselves are durable now — never wiped — so curated data
	// (descriptions/images/album links) survives restarts and rescans.
	err = ldw.artistsRepo.DB.Exec("DELETE FROM artist_tracks").Error
	if err != nil {
		log.Printf("Error clearing artist_tracks table: %v", err)
	}

	for _, f := range files {
		if f.IsDir() {
			continue
		}
		result := ldw.musicRepo.DB.Where("Url = ?", f.Name()).Limit(1).Find(&models.Track{})
		if result.RowsAffected == 0 {
			ldw.saveTrack(f.Name())
		}

		track := models.Track{}
		ldw.musicRepo.DB.Where("Url = ?", f.Name()).First(&track)
		ldw.handleArtists(track.Artist, track.Id)
		ldw.handleAlbum(track)
	}

	ldw.pruneOrphanArtists()
}

// pruneOrphanArtists removes artists left with no tracks, no albums, and no
// curated metadata — i.e. artists that only existed because of tracks now gone.
// Curated artists (with a description or image) are always kept.
func (ldw *LocalDirectoryWorker) pruneOrphanArtists() {
	err := ldw.artistsRepo.DB.Exec(`
		DELETE FROM artists a
		WHERE NOT EXISTS (SELECT 1 FROM artist_tracks at WHERE at.artist_id = a.id)
		  AND NOT EXISTS (SELECT 1 FROM album_artists aa WHERE aa.artist_id = a.id)
		  AND a.description IS NULL AND a.image IS NULL
	`).Error
	if err != nil {
		log.Printf("Error pruning orphan artists: %v", err)
	}
}

// handleAlbum derives an album from the track's embedded TALB (album) frame.
// Only .mp3 files carry ID3 tags. Never overwrites a non-nil AlbumId so manual
// bindings always win over scan-derived ones.
func (ldw *LocalDirectoryWorker) handleAlbum(track models.Track) {
	if track.AlbumId != nil {
		return
	}
	if !strings.EqualFold(filepath.Ext(track.Url), ".mp3") {
		return
	}

	path := filepath.Join(ldw.Cfg.MusicPath, track.Url)
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true, ParseFrames: []string{"TALB"}})
	if err != nil {
		return
	}
	title := strings.TrimSpace(tag.Album())
	tag.Close()
	if title == "" {
		return
	}

	var artistIds []string
	ldw.artistsRepo.DB.
		Table("artist_tracks").
		Where("track_id = ?", track.Id).
		Pluck("artist_id", &artistIds)

	albumId := ldw.albumsRepo.FindOrCreateAlbum(title, artistIds)
	ldw.musicRepo.DB.Model(&models.Track{}).Where("id = ?", track.Id).Update("album_id", albumId)
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

		track := models.Track{}
		ldw.musicRepo.DB.Where("Url = ?", file.Filename).First(&track)
		ldw.handleArtists(track.Artist, track.Id)
		ldw.handleAlbum(track)
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
	ldw.musicRepo.CreateTrack(artists, title, duration, filename, "")
}

func (ldw *LocalDirectoryWorker) handleArtists(artists string, trackId string) {
	// Extract artist names from the track's artist field
	artistNames := strings.Split(artists, ",")

	// Create artist-track entries in the database
	for _, artistName := range artistNames {
		name := strings.TrimSpace(artistName)
		if name == "" {
			continue
		}
		artistId := ldw.artistsRepo.CreateArtist(name)

		err := ldw.artistsRepo.AssociateTrackWithArtist(artistId, trackId)

		if err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}
}
