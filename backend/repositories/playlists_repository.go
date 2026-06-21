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
	repo.DB.AutoMigrate(&models.Playlist{}, &models.PlaylistTrack{})

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

func (repo *PlaylistsRepository) loadOrderedTracks(playlistId string) []models.Track {
	var tracks []models.Track
	repo.DB.Raw(`
		SELECT t.id, t.created_at, t.updated_at, t.deleted_at, t.title, t.artist, t.duration, t.cover, t.url
		FROM tracks t
		JOIN playlist_tracks pt ON pt.track_id = t.id
		WHERE pt.playlist_id = ?
		ORDER BY pt.position ASC, pt.track_id ASC
	`, playlistId).Scan(&tracks)
	if tracks == nil {
		tracks = []models.Track{}
	}
	return tracks
}

func (repo *PlaylistsRepository) GetAllPlaylists(w http.ResponseWriter, r *http.Request) {
	var playlists []models.Playlist
	repo.DB.Model(&models.Playlist{}).Order("created_at").Find(&playlists)
	for i := range playlists {
		playlists[i].Tracks = repo.loadOrderedTracks(playlists[i].Id)
	}
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
	err := repo.DB.Where(&models.Playlist{Id: playlistId}).First(&playlist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
		return
	}
	playlist.Tracks = repo.loadOrderedTracks(playlistId)

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
		return
	}

	var track models.Track
	err = repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}

	var maxPos int

	repo.DB.Model(&models.PlaylistTrack{}).
		Where("playlist_id = ?", playlist.Id).
		Select("COALESCE(MAX(position), -1)").
		Scan(&maxPos)

	repo.DB.Create(&models.PlaylistTrack{
		PlaylistID: playlist.Id,
		TrackID:    track.Id,
		Position:   maxPos + 1,
	})

	playlist.Tracks = repo.loadOrderedTracks(playlist.Id)
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
		return
	}

	var track models.Track
	err = repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}

	repo.DB.Where("playlist_id = ? AND track_id = ?", playlist.Id, track.Id).
		Delete(&models.PlaylistTrack{})

	playlist.Tracks = repo.loadOrderedTracks(playlist.Id)
	respond.RespondJSON(w, http.StatusOK, playlist)
}

func (repo *PlaylistsRepository) ReorderPlaylistTracks(w http.ResponseWriter, r *http.Request) {
	playlistId := mux.Vars(r)["playlistId"]

	var playlist models.Playlist
	if err := repo.DB.Where(&models.Playlist{Id: playlistId}).First(&playlist).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Playlist not found")
		return
	}

	var body struct {
		TrackIds []string `json:"trackIds"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	for i, trackStringId := range body.TrackIds {
		var track models.Track
		if err := repo.DB.Where(&models.Track{Id: trackStringId}).First(&track).Error; err != nil {
			continue
		}
		repo.DB.Model(&models.PlaylistTrack{}).
			Where("playlist_id = ? AND track_id = ?", playlist.Id, track.Id).
			Update("position", i)
	}

	w.WriteHeader(http.StatusNoContent)
}
