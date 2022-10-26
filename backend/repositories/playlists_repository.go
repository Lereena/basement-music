package repositories

import (
	"encoding/json"
	"net/http"

	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type PlaylistsRepository struct {
	DB *gorm.DB
}

func (repo *PlaylistsRepository) Init() {
	repo.DB.AutoMigrate(&models.Playlist{})
}

func (repo *PlaylistsRepository) GetAllPlaylists(w http.ResponseWriter, r *http.Request) {
	var playlists []models.Playlist
	repo.DB.Model(&models.Playlist{}).Preload("Tracks").Find(&playlists)
	json.NewEncoder(w).Encode(&playlists)
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
