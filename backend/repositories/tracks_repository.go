package repositories

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"path/filepath"
	"sort"
	"strings"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/agnivade/levenshtein"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

type TracksRepository struct {
	DB  *gorm.DB
	Cfg *config.Config
}

func (repo *TracksRepository) Init() {
	repo.DB.AutoMigrate(&models.Track{})
}

func (repo *TracksRepository) GetTracks(w http.ResponseWriter, r *http.Request) {
	var tracks []models.Track
	repo.DB.Model(&models.Track{}).Order("created_at DESC").Find(&tracks)
	json.NewEncoder(w).Encode(&tracks)
}

func (repo *TracksRepository) SearchTracks(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query().Get("query")

	urlDecodedQuery, err := url.QueryUnescape(query)
	if err != nil {
		respond.RespondError(w, http.StatusBadRequest, "Failed to decode search query")
		return
	}

	searchQuery := "%" + strings.ToLower(urlDecodedQuery) + "%"

	var tracks []models.Track
	repo.DB.Where("title ILIKE ?", searchQuery).Or("artist ILIKE ?", searchQuery).Table("tracks").Find(&tracks)

	if urlDecodedQuery != "" {
		sort.Slice(tracks, func(i, j int) bool {
			return similarity(tracks[i].Title, searchQuery) > similarity(tracks[j].Title, searchQuery) || similarity(tracks[i].Artist, searchQuery) > similarity(tracks[j].Artist, searchQuery)
		})
	}

	json.NewEncoder(w).Encode(&tracks)
}

func similarity(s1, s2 string) int {
	return levenshtein.ComputeDistance(s1, s2)
}

func (repo *TracksRepository) GetTrackInfo(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	var track models.Track
	repo.DB.Where(&models.Track{Id: params["id"]}).First(&track)
	fmt.Printf("%v", track)

	json.NewEncoder(w).Encode(&track)
}

func (repo *TracksRepository) GetTrack(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	var track models.Track
	repo.DB.Where(&models.Track{Id: params["id"]}).First(&track)
	fmt.Printf("%v", track)

	http.ServeFile(w, r, filepath.Join(repo.Cfg.MusicPath, track.Url))
}

func (repo *TracksRepository) CreateTrack(artist string, title string, duration int, url string, cover string) {
	repo.DB.Create(&models.Track{Id: uuid.New().String(), Artist: artist, Title: title, Duration: duration, Url: url, Cover: cover})
}

func (repo *TracksRepository) EditTrack(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id := params["id"]

	if id == "" {
		respond.RespondError(w, http.StatusBadRequest, "Track id is empty")
		return
	}

	newTitle := strings.TrimSpace(r.FormValue("title"))
	newArtist := strings.TrimSpace(r.FormValue("artist"))
	newCover := strings.TrimSpace(r.FormValue("cover"))

	var track models.Track
	repo.DB.Where(&models.Track{Id: id}).First(&track)

	newTrack := models.Track{}
	if newTitle != "" {
		newTrack.Title = newTitle
	}
	if newArtist != "" {
		newTrack.Artist = newArtist
	}
	if newCover != "" {
		newTrack.Cover = newCover
	}

	repo.DB.Model(&track).Updates(newTrack)

	respond.RespondJSON(w, http.StatusOK, track)
}
