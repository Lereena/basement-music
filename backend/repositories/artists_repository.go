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

type ArtistsRepository struct {
	DB  *gorm.DB
	Cfg *config.Config
}

func (repo *ArtistsRepository) imagesDir() string {
	return filepath.Join(repo.Cfg.MusicPath, "artist_images")
}

func (repo *ArtistsRepository) Init() {
	if err := repo.DB.AutoMigrate(&models.Artist{}); err != nil {
		log.Printf("ArtistsRepository AutoMigrate error: %v", err)
	}
	if err := os.MkdirAll(repo.imagesDir(), 0755); err != nil {
		log.Printf("Failed to create artist_images dir: %v", err)
	}
}

func (repo *ArtistsRepository) GetArtistImage(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	path := filepath.Join(repo.imagesDir(), id)
	if _, err := os.Stat(path); os.IsNotExist(err) {
		respond.RespondError(w, http.StatusNotFound, "image not found")
		return
	}
	http.ServeFile(w, r, path)
}

func (repo *ArtistsRepository) UpdateArtistImage(w http.ResponseWriter, r *http.Request) {
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

	imagePath := "/api/artist/" + id + "/image"
	result := repo.DB.Exec(`UPDATE artists SET Image = ? WHERE Id = ?`, imagePath, id)
	if result.Error != nil {
		log.Printf("UpdateArtistImage DB error: %v", result.Error)
		respond.RespondError(w, http.StatusInternalServerError, "failed to update artist")
		return
	}
	if result.RowsAffected == 0 {
		log.Printf("UpdateArtistImage: no rows updated for id=%s", id)
		respond.RespondError(w, http.StatusNotFound, "artist not found")
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func (repo *ArtistsRepository) GetAllArtists(w http.ResponseWriter, r *http.Request) {
	var artists []models.Artist
	repo.DB.Model(&models.Artist{}).Order("name").Preload("Tracks").Find(&artists)
	json.NewEncoder(w).Encode(&artists)
}

func (repo *ArtistsRepository) GetArtist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id := params["id"]

	var artist models.Artist
	err := repo.DB.Where(&models.Artist{Id: id}).Preload("Tracks").Preload("Albums").First(&artist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	respond.RespondJSON(w, http.StatusOK, artist)
}

// EditArtist updates an artist's name and/or description. On rename, every
// associated track's comma-joined Artist string is rewritten so the next scan
// finds the track under the new name instead of resurrecting the old one.
// PATCH /api/admin/artist/{id}  form: name, description (empty = unchanged)
func (repo *ArtistsRepository) EditArtist(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var artist models.Artist
	if err := repo.DB.Where(&models.Artist{Id: id}).Preload("Tracks").First(&artist).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	newName := strings.TrimSpace(r.FormValue("name"))
	newDescription := strings.TrimSpace(r.FormValue("description"))

	updates := map[string]any{}
	if newDescription != "" {
		updates["description"] = newDescription
	}
	if newName != "" && newName != artist.Name {
		updates["name"] = newName
		repo.renameArtistInTracks(artist, newName)
	}
	if len(updates) > 0 {
		repo.DB.Model(&artist).Updates(updates)
	}

	var updated models.Artist
	repo.DB.Where(&models.Artist{Id: id}).Preload("Tracks").Preload("Albums").First(&updated)
	respond.RespondJSON(w, http.StatusOK, updated)
}

// renameArtistInTracks rewrites the comma-joined Artist string of every track
// associated with the artist, replacing the old name with the new one.
func (repo *ArtistsRepository) renameArtistInTracks(artist models.Artist, newName string) {
	for _, track := range artist.Tracks {
		parts := strings.Split(track.Artist, ",")
		changed := false
		for i, part := range parts {
			if strings.TrimSpace(part) == artist.Name {
				parts[i] = newName
				changed = true
			}
		}
		if changed {
			rejoined := strings.Join(trimAll(parts), ", ")
			repo.DB.Model(&models.Track{}).Where("id = ?", track.Id).Update("artist", rejoined)
		}
	}
}

func trimAll(parts []string) []string {
	out := make([]string, len(parts))
	for i, p := range parts {
		out[i] = strings.TrimSpace(p)
	}
	return out
}

func (repo *ArtistsRepository) CreateArtist(name string) string {
	artist := models.Artist{}

	result := repo.DB.Where("Name = ?", name).First(&artist)
	if result.RowsAffected == 0 {
		artist = models.Artist{
			Id:   uuid.New().String(),
			Name: name,
		}
		repo.DB.Create(&artist)
	}

	return artist.Id
}

func (repo *ArtistsRepository) AssociateTrackWithArtist(artistId string, trackId string) error {
	artist := models.Artist{}
	repo.DB.Where(&models.Artist{Id: artistId}).First(&artist)

	track := models.Track{}
	repo.DB.Where(&models.Track{Id: trackId}).First(&track)

	return repo.DB.Model(&artist).Association("Tracks").Append(&track)
}
