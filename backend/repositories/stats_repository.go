package repositories

import (
	"encoding/json"
	"net/http"
	"strconv"
	"time"

	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

const (
	minListenDurationMs = 4000
	maxListenDurationMs = 6 * 60 * 60 * 1000
	maxBatchSize        = 500
	maxListensPageSize  = 100
)

type StatsRepository struct {
	DB *gorm.DB
}

func (repo *StatsRepository) Init() {
	repo.DB.AutoMigrate(&models.ListenEvent{})
}

type listenEventPayload struct {
	TrackID       string `json:"track_id"`
	DurationMs    int64  `json:"duration_ms"`
	StartedAt     string `json:"started_at"`
	ClientEventID string `json:"client_event_id"`
}

// POST /api/user/listens
func (repo *StatsRepository) PostListens(w http.ResponseWriter, r *http.Request) {
	user, ok := middleware.UserFromContext(r.Context())
	if !ok {
		respond.RespondError(w, http.StatusUnauthorized, "unauthorized")
		return
	}

	var payloads []listenEventPayload
	if err := json.NewDecoder(r.Body).Decode(&payloads); err != nil {
		respond.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if len(payloads) > maxBatchSize {
		respond.RespondError(w, http.StatusBadRequest, "batch too large")
		return
	}

	events := make([]models.ListenEvent, 0, len(payloads))
	for _, p := range payloads {
		if p.TrackID == "" || p.ClientEventID == "" {
			continue
		}
		if p.DurationMs <= minListenDurationMs || p.DurationMs > maxListenDurationMs {
			continue
		}
		startedAt, err := time.Parse(time.RFC3339, p.StartedAt)
		if err != nil {
			continue
		}

		events = append(events, models.ListenEvent{
			UserID:        user.ID,
			TrackID:       p.TrackID,
			DurationMs:    p.DurationMs,
			StartedAt:     startedAt,
			ClientEventID: p.ClientEventID,
		})
	}

	if len(events) > 0 {
		err := repo.DB.Clauses(clause.OnConflict{
			Columns:   []clause.Column{{Name: "client_event_id"}},
			DoNothing: true,
		}).Create(&events).Error
		if err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "failed to store listen events")
			return
		}
	}

	w.WriteHeader(http.StatusCreated)
}

type listenStatResponse struct {
	ID          uint      `json:"id"`
	UserEmail   string    `json:"user_email"`
	TrackID     string    `json:"track_id"`
	TrackTitle  string    `json:"track_title"`
	TrackArtist string    `json:"track_artist"`
	DurationMs  int64     `json:"duration_ms"`
	StartedAt   time.Time `json:"started_at"`
}

type listenStatsPageResponse struct {
	Listens  []listenStatResponse `json:"listens"`
	Total    int64                `json:"total"`
	Page     int                  `json:"page"`
	PageSize int                  `json:"page_size"`
}

// GET /api/admin/listens?page=1&page_size=100
// All users' listen events, newest first.
func (repo *StatsRepository) GetListens(w http.ResponseWriter, r *http.Request) {
	page, err := strconv.Atoi(r.URL.Query().Get("page"))
	if err != nil || page < 1 {
		page = 1
	}
	pageSize, err := strconv.Atoi(r.URL.Query().Get("page_size"))
	if err != nil || pageSize < 1 || pageSize > maxListensPageSize {
		pageSize = maxListensPageSize
	}

	var total int64
	if err := repo.DB.Model(&models.ListenEvent{}).Count(&total).Error; err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to count listen events")
		return
	}

	var events []models.ListenEvent
	err = repo.DB.Order("id DESC").
		Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&events).Error
	if err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to fetch listen events")
		return
	}

	// ListenEvent has no GORM associations (TrackID is the track's UUID
	// string, not its primary key), so resolve users and tracks in two
	// batch lookups instead of Preload.
	userIDs := make([]uint, 0, len(events))
	trackIDs := make([]string, 0, len(events))
	seenUsers := map[uint]bool{}
	seenTracks := map[string]bool{}
	for _, e := range events {
		if !seenUsers[e.UserID] {
			seenUsers[e.UserID] = true
			userIDs = append(userIDs, e.UserID)
		}
		if !seenTracks[e.TrackID] {
			seenTracks[e.TrackID] = true
			trackIDs = append(trackIDs, e.TrackID)
		}
	}

	emailByUserID := map[uint]string{}
	if len(userIDs) > 0 {
		var users []models.User
		repo.DB.Where("id IN ?", userIDs).Find(&users)
		for _, u := range users {
			emailByUserID[u.ID] = u.Email
		}
	}

	trackByID := map[string]models.Track{}
	if len(trackIDs) > 0 {
		var tracks []models.Track
		repo.DB.Where("id IN ?", trackIDs).Find(&tracks)
		for _, t := range tracks {
			trackByID[t.Id] = t
		}
	}

	result := make([]listenStatResponse, len(events))
	for i, e := range events {
		track := trackByID[e.TrackID]
		result[i] = listenStatResponse{
			ID:          e.ID,
			UserEmail:   emailByUserID[e.UserID],
			TrackID:     e.TrackID,
			TrackTitle:  track.Title,
			TrackArtist: track.Artist,
			DurationMs:  e.DurationMs,
			StartedAt:   e.StartedAt,
		}
	}

	respond.RespondJSON(w, http.StatusOK, listenStatsPageResponse{
		Listens:  result,
		Total:    total,
		Page:     page,
		PageSize: pageSize,
	})
}
