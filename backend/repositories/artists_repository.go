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

	// Create a new slice to hold artists without tracks
	var artistsWithoutTracks []map[string]interface{}
	for _, artist := range artists {
		artistWithoutTracks := map[string]interface{}{
			"Id":    artist.Id,
			"Name":  artist.Name,
			"Image": artist.Image,
		}
		artistsWithoutTracks = append(artistsWithoutTracks, artistWithoutTracks)
	}

	json.NewEncoder(w).Encode(&artistsWithoutTracks)
}

func (repo *ArtistsRepository) GetArtist(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id := params["id"]

	var artist models.Artist
	err := repo.DB.Where(&models.Artist{Id: id}).First(&artist).Error
	if err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	respond.RespondJSON(w, http.StatusOK, artist)
}
