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

type ArtistsRepository struct {
	DB *gorm.DB
}

func (repo *ArtistsRepository) Init() {
	repo.DB.AutoMigrate(&models.Artist{})
}

func (repo *ArtistsRepository) GetAllArtists(w http.ResponseWriter, r *http.Request) {
	var artists []models.Artist
	repo.DB.Model(&models.Artist{}).Order("name").Find(&artists)
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
