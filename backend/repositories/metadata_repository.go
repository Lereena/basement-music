package repositories

import (
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/musicbrainz"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type MetadataRepository struct {
	DB  *gorm.DB
	Cfg *config.Config
	MB  *musicbrainz.Client
}

func (repo *MetadataRepository) artistImagesDir() string {
	return filepath.Join(repo.Cfg.MusicPath, "artist_images")
}

func (repo *MetadataRepository) albumImagesDir() string {
	return filepath.Join(repo.Cfg.MusicPath, "album_images")
}

// SearchArtistMetadata returns MusicBrainz artist candidates.
// GET /admin/artist/{id}/metadata/search?query= (default: artist name)
func (repo *MetadataRepository) SearchArtistMetadata(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]

	var artist models.Artist
	if err := repo.DB.Where(&models.Artist{Id: id}).First(&artist).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	query := strings.TrimSpace(r.URL.Query().Get("query"))
	if query == "" {
		query = artist.Name
	}

	candidates, err := repo.MB.SearchArtists(query)
	if err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Metadata provider unavailable")
		return
	}

	respond.RespondJSON(w, http.StatusOK, candidates)
}

// PreviewArtistMetadata resolves description + image for a chosen MBID.
// GET /admin/artist/{id}/metadata/preview?mbid=
func (repo *MetadataRepository) PreviewArtistMetadata(w http.ResponseWriter, r *http.Request) {
	mbid := strings.TrimSpace(r.URL.Query().Get("mbid"))
	if mbid == "" {
		respond.RespondError(w, http.StatusBadRequest, "mbid is required")
		return
	}

	details, err := repo.MB.GetArtistDetails(mbid)
	if err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Metadata provider unavailable")
		return
	}
	if details.Description == "" && details.ImageUrl == "" {
		respond.RespondError(w, http.StatusNotFound, "No metadata found")
		return
	}

	respond.RespondJSON(w, http.StatusOK, map[string]string{
		"Description": details.Description,
		"ImageUrl":    details.ImageUrl,
	})
}

// ApplyArtistMetadata saves the user-confirmed description and downloads the
// chosen image into artist_images/{id}.
// POST /admin/artist/{id}/metadata/apply  form: description, imageUrl
func (repo *MetadataRepository) ApplyArtistMetadata(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	if err := r.ParseForm(); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "failed to parse form")
		return
	}

	var artist models.Artist
	if err := repo.DB.Where(&models.Artist{Id: id}).First(&artist).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Artist not found")
		return
	}

	updates := map[string]any{}
	if description := strings.TrimSpace(r.FormValue("description")); description != "" {
		updates["description"] = description
	}

	if imageUrl := strings.TrimSpace(r.FormValue("imageUrl")); imageUrl != "" {
		data, err := repo.MB.DownloadImage(imageUrl)
		if err == nil && data != nil {
			path := filepath.Join(repo.artistImagesDir(), id)
			if os.WriteFile(path, data, 0644) == nil {
				updates["image"] = "/api/artist/" + id + "/image"
			}
		}
	}

	if len(updates) > 0 {
		repo.DB.Model(&artist).Updates(updates)
	}

	var updated models.Artist
	repo.DB.Where(&models.Artist{Id: id}).Preload("Tracks").Preload("Albums").First(&updated)
	respond.RespondJSON(w, http.StatusOK, updated)
}

// SearchAlbumCover returns release-group candidates with CAA thumbnails.
// GET /admin/album/{id}/cover/search?query= (default: title + first artist)
func (repo *MetadataRepository) SearchAlbumCover(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]

	var album models.Album
	if err := repo.DB.Where(&models.Album{Id: id}).Preload("Artists").First(&album).Error; err != nil {
		respond.RespondError(w, http.StatusNotFound, "Album not found")
		return
	}

	query := strings.TrimSpace(r.URL.Query().Get("query"))
	title := album.Title
	artist := ""
	if len(album.Artists) > 0 {
		artist = album.Artists[0].Name
	}
	if query != "" {
		title = query
	}

	candidates, err := repo.MB.SearchReleaseGroups(artist, title)
	if err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Metadata provider unavailable")
		return
	}

	respond.RespondJSON(w, http.StatusOK, candidates)
}

// ApplyAlbumCover downloads the chosen release-group's front cover into
// album_images/{id}.
// POST /admin/album/{id}/cover/apply  form: mbid
func (repo *MetadataRepository) ApplyAlbumCover(w http.ResponseWriter, r *http.Request) {
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

	mbid := strings.TrimSpace(r.FormValue("mbid"))
	if mbid == "" {
		respond.RespondError(w, http.StatusBadRequest, "mbid is required")
		return
	}

	data, err := repo.MB.DownloadImage(repo.MB.CoverUrl(mbid))
	if err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Cover provider unavailable")
		return
	}
	if data == nil {
		respond.RespondError(w, http.StatusNotFound, "No cover found")
		return
	}

	path := filepath.Join(repo.albumImagesDir(), id)
	if err := os.WriteFile(path, data, 0644); err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to save cover")
		return
	}

	coverPath := "/api/album/" + id + "/image"
	repo.DB.Model(&album).Update("cover", coverPath)

	var updated models.Album
	repo.DB.Where(&models.Album{Id: id}).Preload("Artists").First(&updated)
	respond.RespondJSON(w, http.StatusOK, updated)
}
