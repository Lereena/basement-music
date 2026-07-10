package repositories

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type AlbumsRepository struct {
	DB  *gorm.DB
	Cfg *config.Config
}

func (repo *AlbumsRepository) imagesDir() string {
	return filepath.Join(repo.Cfg.MusicPath, "album_images")
}

func (repo *AlbumsRepository) Init() {
	if err := repo.DB.AutoMigrate(&models.Album{}); err != nil {
		log.Printf("AlbumsRepository AutoMigrate error: %v", err)
	}
	if err := os.MkdirAll(repo.imagesDir(), 0755); err != nil {
		log.Printf("Failed to create album_images dir: %v", err)
	}
}

// loadAlbum fetches an album with its artists and ordered tracks.
func (repo *AlbumsRepository) loadAlbum(id string) (models.Album, bool) {
	var album models.Album
	err := repo.DB.Where(&models.Album{Id: id}).Preload("Artists").First(&album).Error
	if err != nil {
		return album, false
	}
	var tracks []models.Track
	repo.DB.Where("album_id = ?", id).Order("album_position ASC, title ASC").Find(&tracks)
	album.Tracks = tracks
	return album, true
}

func (repo *AlbumsRepository) GetAllAlbums(w http.ResponseWriter, r *http.Request) {
	var albums []models.Album
	repo.DB.Model(&models.Album{}).Order("title").Preload("Artists").Find(&albums)
	respond.RespondJSON(w, http.StatusOK, albums)
}

func (repo *AlbumsRepository) GetAlbum(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	album, ok := repo.loadAlbum(id)
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}
	respond.RespondJSON(w, http.StatusOK, album)
}

func (repo *AlbumsRepository) GetAlbumImage(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	path := filepath.Join(repo.imagesDir(), id)
	if _, err := os.Stat(path); os.IsNotExist(err) {
		respond.RespondError(w, http.StatusNotFound, "image not found")
		return
	}
	http.ServeFile(w, r, path)
}

// FindOrCreateAlbum finds an album by title (case-insensitive) or creates one,
// binding the given artists. Used by scan-time TALB derivation.
func (repo *AlbumsRepository) FindOrCreateAlbum(title string, artistIds []string) string {
	title = strings.TrimSpace(title)

	var album models.Album
	result := repo.DB.Where("title ILIKE ?", title).First(&album)
	if result.RowsAffected == 0 {
		album = models.Album{Id: uuid.New().String(), Title: title}
		repo.DB.Create(&album)
	}

	for _, artistId := range artistIds {
		var artist models.Artist
		if repo.DB.Where(&models.Artist{Id: artistId}).First(&artist).Error == nil {
			repo.DB.Model(&album).Association("Artists").Append(&artist)
		}
	}

	return album.Id
}

func (repo *AlbumsRepository) CreateAlbum(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}
	title := strings.TrimSpace(r.FormValue("title"))
	if title == "" {
		respond.RespondError(w, http.StatusBadRequest, "title is empty")
		return
	}

	album := models.Album{Id: uuid.New().String(), Title: title}
	if err := repo.DB.Create(&album).Error; err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to create album")
		return
	}

	for _, artistId := range r.Form["artistIds"] {
		var artist models.Artist
		if repo.DB.Where(&models.Artist{Id: artistId}).First(&artist).Error == nil {
			repo.DB.Model(&album).Association("Artists").Append(&artist)
		}
	}

	loaded, _ := repo.loadAlbum(album.Id)
	respond.RespondJSON(w, http.StatusOK, loaded)
}

func (repo *AlbumsRepository) EditAlbum(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: id}).First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	updates := map[string]any{}
	if title := strings.TrimSpace(r.FormValue("title")); title != "" {
		updates["title"] = title
	}
	if yearStr := strings.TrimSpace(r.FormValue("year")); yearStr != "" {
		if year, err := strconv.Atoi(yearStr); err == nil {
			updates["year"] = year
		}
	}
	if len(updates) > 0 {
		repo.DB.Model(&album).Updates(updates)
	}

	loaded, _ := repo.loadAlbum(id)
	respond.RespondJSON(w, http.StatusOK, loaded)
}

func (repo *AlbumsRepository) DeleteAlbum(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: id}).First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	// Unbind tracks, clear artist associations, drop image file, then delete.
	repo.DB.Model(&models.Track{}).Where("album_id = ?", id).
		Updates(map[string]any{"album_id": nil, "album_position": 0})
	repo.DB.Model(&album).Association("Artists").Clear()
	os.Remove(filepath.Join(repo.imagesDir(), id))
	repo.DB.Delete(&album)

	w.WriteHeader(http.StatusNoContent)
}

func (repo *AlbumsRepository) SetAlbumArtists(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: id}).First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	var artists []models.Artist
	for _, artistId := range r.Form["artistIds"] {
		var artist models.Artist
		if repo.DB.Where(&models.Artist{Id: artistId}).First(&artist).Error == nil {
			artists = append(artists, artist)
		}
	}
	repo.DB.Model(&album).Association("Artists").Replace(artists)

	loaded, _ := repo.loadAlbum(id)
	respond.RespondJSON(w, http.StatusOK, loaded)
}

// SetAlbumTracks replaces the album's track set with the ordered trackIds:
// tracks absent from the list are unbound, present ones get album_id + position.
func (repo *AlbumsRepository) SetAlbumTracks(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: id}).First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	trackIds := r.Form["trackIds"]

	// Unbind tracks currently on the album but not in the new list.
	if len(trackIds) > 0 {
		repo.DB.Model(&models.Track{}).
			Where("album_id = ? AND id NOT IN ?", id, trackIds).
			Updates(map[string]any{"album_id": nil, "album_position": 0})
	} else {
		repo.DB.Model(&models.Track{}).Where("album_id = ?", id).
			Updates(map[string]any{"album_id": nil, "album_position": 0})
	}

	// Bind + order the listed tracks.
	for i, trackId := range trackIds {
		repo.DB.Model(&models.Track{}).Where("id = ?", trackId).
			Updates(map[string]any{"album_id": id, "album_position": i})
	}

	loaded, _ := repo.loadAlbum(id)
	respond.RespondJSON(w, http.StatusOK, loaded)
}

// SetTrackAlbum binds a single track to an album (empty albumId = unbind).
// Position is placed after the current last track of the album.
func (repo *AlbumsRepository) SetTrackAlbum(w http.ResponseWriter, r *http.Request) {
	trackId := mux.Vars(r)["trackId"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var track models.Track
	if err := repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}

	albumId := strings.TrimSpace(r.FormValue("albumId"))
	if albumId == "" {
		repo.DB.Model(&models.Track{}).Where("id = ?", trackId).
			Updates(map[string]any{"album_id": nil, "album_position": 0})
		w.WriteHeader(http.StatusNoContent)
		return
	}

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: albumId}).First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	var maxPos int
	repo.DB.Model(&models.Track{}).Where("album_id = ?", albumId).
		Select("COALESCE(MAX(album_position), -1)").Scan(&maxPos)

	repo.DB.Model(&models.Track{}).Where("id = ?", trackId).
		Updates(map[string]any{"album_id": albumId, "album_position": maxPos + 1})

	w.WriteHeader(http.StatusNoContent)
}

func (repo *AlbumsRepository) UpdateAlbumImage(w http.ResponseWriter, r *http.Request) {
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

	coverPath := "/api/album/" + id + "/image"
	result := repo.DB.Model(&models.Album{}).Where("id = ?", id).Update("cover", coverPath)
	if result.Error != nil {
		log.Printf("UpdateAlbumImage DB error: %v", result.Error)
		respond.RespondError(w, http.StatusInternalServerError, "failed to update album")
		return
	}
	if result.RowsAffected == 0 {
		respond.RespondError(w, http.StatusNotFound, "album not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
