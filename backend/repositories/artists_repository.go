package repositories

import (
	"encoding/json"
	"net/http"

	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
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
