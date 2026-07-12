package repositories

import (
	"encoding/json"
	"log"
	"net/http"
	"net/url"
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
	// Callers append ?v=<updatedAt>, so a new URL is minted whenever the image
	// changes — safe to tell clients to never revalidate.
	w.Header().Set("Cache-Control", "public, max-age=31536000, immutable")
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
	result := repo.DB.Exec(`UPDATE artists SET image = ?, updated_at = NOW() WHERE id = ?`, imagePath, id)
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
	repo.DB.Model(&models.Artist{}).Order("name").Preload("Tracks").Preload("Albums").Find(&artists)
	json.NewEncoder(w).Encode(&artists)
}

func (repo *ArtistsRepository) SearchArtists(w http.ResponseWriter, r *http.Request) {
	query, err := url.QueryUnescape(r.URL.Query().Get("query"))
	if err != nil {
		respond.RespondError(w, http.StatusBadRequest, "Failed to decode search query")
		return
	}

	var artists []models.Artist
	if strings.TrimSpace(query) == "" {
		json.NewEncoder(w).Encode(&[]models.Artist{})
		return
	}

	searchQuery := "%" + strings.ToLower(query) + "%"
	repo.DB.Model(&models.Artist{}).Where("name ILIKE ?", searchQuery).Order("name").Preload("Tracks").Find(&artists)

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

// SetTrackArtists rebinds a track to an explicit set of artists, replacing its
// artist_tracks links directly (entity-level, no rescan needed). It also rewrites
// the track's comma-joined Artist string to match so the next directory scan
// doesn't revert the binding, then prunes any artist left orphaned by the change.
// PATCH /api/admin/track/{trackId}/artists  form: repeated artistIds
func (repo *ArtistsRepository) SetTrackArtists(w http.ResponseWriter, r *http.Request) {
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

	var artists []models.Artist
	var names []string
	for _, artistId := range r.Form["artistIds"] {
		var artist models.Artist
		if repo.DB.Where(&models.Artist{Id: artistId}).First(&artist).Error == nil {
			artists = append(artists, artist)
			names = append(names, artist.Name)
		}
	}

	// Rebuild this track's artist links from scratch.
	repo.DB.Exec("DELETE FROM artist_tracks WHERE track_id = ?", trackId)
	for i := range artists {
		if err := repo.DB.Model(&artists[i]).Association("Tracks").Append(&track); err != nil {
			log.Printf("SetTrackArtists append error: %v", err)
		}
	}

	// Keep the free-text Artist string in sync so a rescan won't resurrect the
	// old binding from stale text.
	newArtist := strings.Join(names, ", ")
	repo.DB.Model(&models.Track{}).Where("id = ?", trackId).Update("artist", newArtist)
	track.Artist = newArtist

	repo.pruneOrphanArtists()

	respond.RespondJSON(w, http.StatusOK, track)
}

// pruneOrphanArtists removes artists with no tracks, no albums, and no curated
// metadata — mirrors the scan-time prune so rebinds don't leave dangling artists.
func (repo *ArtistsRepository) pruneOrphanArtists() {
	err := repo.DB.Exec(`
		DELETE FROM artists a
		WHERE NOT EXISTS (SELECT 1 FROM artist_tracks at WHERE at.artist_id = a.id)
		  AND NOT EXISTS (SELECT 1 FROM album_artists aa WHERE aa.artist_id = a.id)
		  AND a.description IS NULL AND a.image IS NULL
	`).Error
	if err != nil {
		log.Printf("Error pruning orphan artists: %v", err)
	}
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
