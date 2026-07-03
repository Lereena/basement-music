package repositories

import (
	"encoding/json"
	"net/http"
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
	user, _ := middleware.UserFromContext(r.Context())

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
		repo.DB.Clauses(clause.OnConflict{
			Columns:   []clause.Column{{Name: "client_event_id"}},
			DoNothing: true,
		}).Create(&events)
	}

	w.WriteHeader(http.StatusCreated)
}
