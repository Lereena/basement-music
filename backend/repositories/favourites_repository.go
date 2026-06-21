package repositories

import (
	"encoding/json"
	"net/http"

	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type FavouritesRepository struct {
	DB *gorm.DB
}

// GET /api/user/favourites
func (repo *FavouritesRepository) GetFavourites(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())

	var favs []models.Favourite
	repo.DB.Where("user_id = ?", user.ID).Order("created_at DESC").Find(&favs)

	trackIDs := make([]string, len(favs))
	for i, f := range favs {
		trackIDs[i] = f.TrackID
	}

	var tracks []models.Track
	if len(trackIDs) > 0 {
		repo.DB.Where("id IN ?", trackIDs).Find(&tracks)

		trackMap := make(map[string]models.Track, len(tracks))
		for _, t := range tracks {
			trackMap[t.Id] = t
		}
		tracks = make([]models.Track, 0, len(trackIDs))
		for _, id := range trackIDs {
			if t, ok := trackMap[id]; ok {
				tracks = append(tracks, t)
			}
		}
	}

	json.NewEncoder(w).Encode(tracks)
}

// POST /api/user/favourites/{trackId}
func (repo *FavouritesRepository) AddFavourite(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	trackID := mux.Vars(r)["trackId"]

	fav := models.Favourite{UserID: user.ID, TrackID: trackID}
	repo.DB.Where(fav).FirstOrCreate(&fav)

	w.WriteHeader(http.StatusCreated)
}

// DELETE /api/user/favourites/{trackId}
func (repo *FavouritesRepository) RemoveFavourite(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	trackID := mux.Vars(r)["trackId"]

	repo.DB.Where("user_id = ? AND track_id = ?", user.ID, trackID).Delete(&models.Favourite{})
	respond.RespondError(w, http.StatusNoContent, "")
}
