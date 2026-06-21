package repositories

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type PlaylistsRepository struct {
	DB  *gorm.DB
	Cfg *config.Config
}

func (repo *PlaylistsRepository) imagesDir() string {
	return filepath.Join(repo.Cfg.MusicPath, "playlist_images")
}

func (repo *PlaylistsRepository) Init() {
	repo.DB.AutoMigrate(&models.Playlist{})
	if err := os.MkdirAll(repo.imagesDir(), 0755); err != nil {
		log.Printf("Failed to create playlist_images dir: %v", err)
	}
}

func (repo *PlaylistsRepository) GetPlaylistImage(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	path := filepath.Join(repo.imagesDir(), id)
	if _, err := os.Stat(path); os.IsNotExist(err) {
		respond.RespondError(w, http.StatusNotFound, "image not found")
		return
	}
	http.ServeFile(w, r, path)
}

func (repo *PlaylistsRepository) UpdatePlaylistImage(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]

	if err := r.ParseMultipartForm(10 << 20); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	file, _, err := r.FormFile("image")
	if err != nil {
		respond.RespondError(w, http.StatusBadRequest, "image field required")
		return
	}
	defer file.Close()

	dst, err := os.Create(filepath.Join(repo.imagesDir(), id))
	if err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to save image")
		return
	}
	defer dst.Close()

	buf := make([]byte, 32*1024)
	for {
		n, readErr := file.Read(buf)
		if n > 0 {
			if _, writeErr := dst.Write(buf[:n]); writeErr != nil {
				respond.RespondError(w, http.StatusInternalServerError, "failed to write image")
				return
			}
		}
		if readErr != nil {
			break
		}
	}

	imagePath := "/api/playlist/" + id + "/image"
	result := repo.DB.Exec(`UPDATE playlists SET Image = ? WHERE Id = ?`, imagePath, id)
	if result.Error != nil {
		log.Printf("UpdatePlaylistImage DB error: %v", result.Error)
		respond.RespondError(w, http.StatusInternalServerError, "failed to update playlist")
		return
	}
	if result.RowsAffected == 0 {
		log.Printf("UpdatePlaylistImage: no rows updated for id=%s", id)
		respond.RespondError(w, http.StatusNotFound, "playlist not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (repo *PlaylistsRepository) GetAllPlaylists(w http.ResponseWriter, r *http.Request) {
	var playlists []models.Playlist
	repo.DB.Model(&models.Playlist{}).Preload("Tracks").Order("created_at").Find(&playlists)
	json.NewEncoder(w).Encode(playlists)
}

func (repo *PlaylistsRepository) CreatePlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	title := params["title"]
	if title == "" {
		respond.RespondError(w, http.StatusBadRequest, "Playlist title is empty")
		return
	}

	newPlaylist := &models.Playlist{Id: uuid.New().String(), Title: title, Tracks: []models.Track{}}
	repo.DB.Create(newPlaylist)

	json.NewEncoder(w).Encode(newPlaylist)
}

func (repo *PlaylistsRepository) EditPlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id := params["id"]
	title := strings.TrimSpace(r.FormValue("title"))

	if id == "" {
		respond.RespondError(w, http.StatusBadRequest, "Playlist id is empty")
		return
	}

	if title == "" {
		respond.RespondError(w, http.StatusBadRequest, "Playlist title is empty")
		return
	}

	var playlist models.Playlist
	repo.DB.Where(&models.Playlist{Id: id}).First(&playlist)

	repo.DB.Model(&playlist).Update("title", title)
}

func (repo *PlaylistsRepository) DeletePlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	playlistId := params["id"]

	var playlist models.Playlist
	err := repo.DB.Where(&models.Playlist{Id: playlistId}).First(&playlist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
	}

	repo.DB.Delete(playlist)
}

func (repo *PlaylistsRepository) GetPlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	playlistId := params["id"]

	var playlist models.Playlist
	err := repo.DB.Where(&models.Playlist{Id: playlistId}).Preload("Tracks").First(&playlist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
	}

	respond.RespondJSON(w, http.StatusOK, playlist)
}

func (repo *PlaylistsRepository) AddTrackToPlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	playlistId := params["playlistId"]
	trackId := params["trackId"]

	var playlist models.Playlist
	err := repo.DB.Where(&models.Playlist{Id: playlistId}).First(&playlist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
	}

	var track models.Track
	err = repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
	}

	repo.DB.Model(&playlist).Association("Tracks").Append([]models.Track{track})

	respond.RespondJSON(w, http.StatusOK, playlist)
}

func (repo *PlaylistsRepository) DeleteTrackFromPlaylist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	playlistId := params["playlistId"]
	trackId := params["trackId"]

	var playlist models.Playlist
	err := repo.DB.Where(&models.Playlist{Id: playlistId}).First(&playlist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
	}

	var track models.Track
	err = repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
	}

	repo.DB.Model(&playlist).Association("Tracks").Delete([]models.Track{track})

	respond.RespondJSON(w, http.StatusOK, playlist)
}
