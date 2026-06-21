package repositories

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"path/filepath"

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
	err := repo.DB.Where(&models.Artist{Id: id}).Preload("Tracks").First(&artist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	respond.RespondJSON(w, http.StatusOK, artist)
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
