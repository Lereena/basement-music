package repositories

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type FavouritesRepository struct {
	DB        *gorm.DB
	Playlists *PlaylistsRepository
}

func (repo *FavouritesRepository) Init() {
	if err := repo.DB.AutoMigrate(&models.Favourite{}); err != nil {
		log.Printf("FavouritesRepository AutoMigrate error: %v", err)
	}

	// Legacy schema stored only tracks in a track_id column; move data to item_type/item_id.
	migrator := repo.DB.Migrator()
	if migrator.HasColumn(&models.Favourite{}, "track_id") {
		repo.DB.Exec(
			`UPDATE favourites SET item_id = track_id, item_type = 'track' WHERE item_id = '' AND track_id IS NOT NULL`,
		)
		if err := migrator.DropColumn(&models.Favourite{}, "track_id"); err != nil {
			log.Printf("FavouritesRepository drop track_id error: %v", err)
		}
	}
}

var favouriteItemTypes = map[string]bool{
	models.FavouriteTrack:    true,
	models.FavouritePlaylist: true,
	models.FavouriteArtist:   true,
	models.FavouriteAlbum:    true,
}

// favouriteIDs returns item IDs of the given type, most recently favourited first.
func (repo *FavouritesRepository) favouriteIDs(userID uint, itemType string) []string {
	var favs []models.Favourite
	repo.DB.Where("user_id = ? AND item_type = ?", userID, itemType).Order("created_at DESC").Find(&favs)

	ids := make([]string, len(favs))
	for i, f := range favs {
		ids[i] = f.ItemID
	}
	return ids
}

// GET /api/user/favourites
func (repo *FavouritesRepository) GetFavourites(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	ids := repo.favouriteIDs(user.ID, models.FavouriteTrack)

	tracks := []models.Track{}
	if len(ids) > 0 {
		var found []models.Track
		repo.DB.Where("id IN ?", ids).Find(&found)

		trackMap := make(map[string]models.Track, len(found))
		for _, t := range found {
			trackMap[t.Id] = t
		}
		for _, id := range ids {
			if t, ok := trackMap[id]; ok {
				tracks = append(tracks, t)
			}
		}
	}

	json.NewEncoder(w).Encode(tracks)
}

// GET /api/user/favourites/playlists
func (repo *FavouritesRepository) GetFavouritePlaylists(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	ids := repo.favouriteIDs(user.ID, models.FavouritePlaylist)

	playlists := []models.Playlist{}
	if len(ids) > 0 {
		var found []models.Playlist
		repo.DB.Where("id IN ?", ids).Find(&found)

		playlistMap := make(map[string]models.Playlist, len(found))
		for _, p := range found {
			playlistMap[p.Id] = p
		}
		for _, id := range ids {
			if p, ok := playlistMap[id]; ok {
				p.Tracks = repo.Playlists.loadOrderedTracks(p.Id)
				playlists = append(playlists, p)
			}
		}
	}

	json.NewEncoder(w).Encode(playlists)
}

// GET /api/user/favourites/artists
func (repo *FavouritesRepository) GetFavouriteArtists(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	ids := repo.favouriteIDs(user.ID, models.FavouriteArtist)

	artists := []models.Artist{}
	if len(ids) > 0 {
		var found []models.Artist
		repo.DB.Where("id IN ?", ids).Preload("Tracks").Preload("Albums").Find(&found)

		artistMap := make(map[string]models.Artist, len(found))
		for _, a := range found {
			artistMap[a.Id] = a
		}
		for _, id := range ids {
			if a, ok := artistMap[id]; ok {
				artists = append(artists, a)
			}
		}
	}

	json.NewEncoder(w).Encode(artists)
}

// GET /api/user/favourites/albums
func (repo *FavouritesRepository) GetFavouriteAlbums(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	ids := repo.favouriteIDs(user.ID, models.FavouriteAlbum)

	albums := []models.Album{}
	if len(ids) > 0 {
		var found []models.Album
		repo.DB.Where("id IN ?", ids).Preload("Artists").Find(&found)

		albumMap := make(map[string]models.Album, len(found))
		for _, a := range found {
			albumMap[a.Id] = a
		}
		for _, id := range ids {
			if a, ok := albumMap[id]; ok {
				albums = append(albums, a)
			}
		}
	}

	json.NewEncoder(w).Encode(albums)
}

// POST /api/user/favourites/{itemType}/{id}
func (repo *FavouritesRepository) AddFavouriteItem(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	vars := mux.Vars(r)
	itemType, itemID := vars["itemType"], vars["id"]

	if !favouriteItemTypes[itemType] {
		respond.RespondError(w, http.StatusBadRequest, "unknown favourite item type")
		return
	}

	fav := models.Favourite{UserID: user.ID, ItemType: itemType, ItemID: itemID}
	repo.DB.Where(fav).FirstOrCreate(&fav)

	w.WriteHeader(http.StatusCreated)
}

// DELETE /api/user/favourites/{itemType}/{id}
func (repo *FavouritesRepository) RemoveFavouriteItem(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	vars := mux.Vars(r)
	itemType, itemID := vars["itemType"], vars["id"]

	if !favouriteItemTypes[itemType] {
		respond.RespondError(w, http.StatusBadRequest, "unknown favourite item type")
		return
	}

	repo.DB.Where("user_id = ? AND item_type = ? AND item_id = ?", user.ID, itemType, itemID).
		Delete(&models.Favourite{})
	respond.RespondError(w, http.StatusNoContent, "")
}

// POST /api/user/favourites/{trackId} — legacy route kept for older clients.
func (repo *FavouritesRepository) AddFavourite(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	trackID := mux.Vars(r)["trackId"]

	fav := models.Favourite{UserID: user.ID, ItemType: models.FavouriteTrack, ItemID: trackID}
	repo.DB.Where(fav).FirstOrCreate(&fav)

	w.WriteHeader(http.StatusCreated)
}

// DELETE /api/user/favourites/{trackId} — legacy route kept for older clients.
func (repo *FavouritesRepository) RemoveFavourite(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	trackID := mux.Vars(r)["trackId"]

	repo.DB.Where("user_id = ? AND item_type = ? AND item_id = ?", user.ID, models.FavouriteTrack, trackID).
		Delete(&models.Favourite{})
	respond.RespondError(w, http.StatusNoContent, "")
}
