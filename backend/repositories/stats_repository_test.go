package repositories

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"
	"time"

	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func newStatsRepo(t *testing.T) *StatsRepository {
	t.Helper()
	db, err := gorm.Open(
		sqlite.Open(filepath.Join(t.TempDir(), "stats.db")),
		&gorm.Config{Logger: logger.Default.LogMode(logger.Silent)},
	)
	if err != nil {
		t.Fatalf("open sqlite: %v", err)
	}
	if err := db.AutoMigrate(&models.User{}, &models.Track{}); err != nil {
		t.Fatalf("migrate users/tracks: %v", err)
	}
	repo := &StatsRepository{DB: db}
	repo.Init()
	return repo
}

func getListens(t *testing.T, repo *StatsRepository, query string) listenStatsPageResponse {
	t.Helper()
	req := httptest.NewRequest(http.MethodGet, "/admin/listens"+query, nil)
	w := httptest.NewRecorder()
	repo.GetListens(w, req)
	if w.Code != http.StatusOK {
		t.Fatalf("GetListens status = %d, want %d", w.Code, http.StatusOK)
	}
	var page listenStatsPageResponse
	if err := json.NewDecoder(w.Body).Decode(&page); err != nil {
		t.Fatalf("decode page: %v", err)
	}
	return page
}

func postListens(t *testing.T, repo *StatsRepository, user *models.User, body any) *httptest.ResponseRecorder {
	t.Helper()
	var buf bytes.Buffer
	switch b := body.(type) {
	case string:
		buf.WriteString(b)
	default:
		if err := json.NewEncoder(&buf).Encode(body); err != nil {
			t.Fatalf("encode body: %v", err)
		}
	}

	req := httptest.NewRequest(http.MethodPost, "/user/listens", &buf)
	if user != nil {
		req = req.WithContext(context.WithValue(req.Context(), middleware.UserContextKey, user))
	}
	w := httptest.NewRecorder()
	repo.PostListens(w, req)
	return w
}

func validPayload(clientEventID string) map[string]any {
	return map[string]any{
		"track_id":        "track-1",
		"duration_ms":     30000,
		"started_at":      time.Now().UTC().Format(time.RFC3339),
		"client_event_id": clientEventID,
	}
}

func countEvents(t *testing.T, repo *StatsRepository) int64 {
	t.Helper()
	var count int64
	if err := repo.DB.Model(&models.ListenEvent{}).Count(&count).Error; err != nil {
		t.Fatalf("count events: %v", err)
	}
	return count
}

func TestPostListensStoresValidEvents(t *testing.T) {
	repo := newStatsRepo(t)
	user := &models.User{Model: gorm.Model{ID: 42}}

	w := postListens(t, repo, user, []map[string]any{validPayload("e1"), validPayload("e2")})

	if w.Code != http.StatusCreated {
		t.Fatalf("status = %d, want %d", w.Code, http.StatusCreated)
	}
	if got := countEvents(t, repo); got != 2 {
		t.Fatalf("stored %d events, want 2", got)
	}

	var event models.ListenEvent
	if err := repo.DB.Where("client_event_id = ?", "e1").First(&event).Error; err != nil {
		t.Fatalf("find event: %v", err)
	}
	if event.UserID != 42 {
		t.Fatalf("UserID = %d, want 42 (must come from auth context)", event.UserID)
	}
}

func TestPostListensIsIdempotent(t *testing.T) {
	repo := newStatsRepo(t)
	user := &models.User{Model: gorm.Model{ID: 1}}
	batch := []map[string]any{validPayload("e1"), validPayload("e2")}

	first := postListens(t, repo, user, batch)
	second := postListens(t, repo, user, batch)

	if first.Code != http.StatusCreated || second.Code != http.StatusCreated {
		t.Fatalf("statuses = %d, %d, want both %d", first.Code, second.Code, http.StatusCreated)
	}
	if got := countEvents(t, repo); got != 2 {
		t.Fatalf("stored %d events after duplicate batch, want 2", got)
	}
}

func TestPostListensSkipsInvalidRowsKeepsValid(t *testing.T) {
	repo := newStatsRepo(t)
	user := &models.User{Model: gorm.Model{ID: 1}}

	tooShort := validPayload("too-short")
	tooShort["duration_ms"] = minListenDurationMs

	tooLong := validPayload("too-long")
	tooLong["duration_ms"] = maxListenDurationMs + 1

	noTrack := validPayload("no-track")
	noTrack["track_id"] = ""

	noEventID := validPayload("")

	badTime := validPayload("bad-time")
	badTime["started_at"] = "yesterday"

	w := postListens(t, repo, user, []map[string]any{
		tooShort, tooLong, noTrack, noEventID, badTime, validPayload("valid"),
	})

	if w.Code != http.StatusCreated {
		t.Fatalf("status = %d, want %d", w.Code, http.StatusCreated)
	}
	if got := countEvents(t, repo); got != 1 {
		t.Fatalf("stored %d events, want only the valid one", got)
	}
	var event models.ListenEvent
	if err := repo.DB.First(&event).Error; err != nil {
		t.Fatalf("find event: %v", err)
	}
	if event.ClientEventID != "valid" {
		t.Fatalf("stored event %q, want %q", event.ClientEventID, "valid")
	}
}

func TestPostListensRejectsOversizedBatch(t *testing.T) {
	repo := newStatsRepo(t)
	user := &models.User{Model: gorm.Model{ID: 1}}

	batch := make([]map[string]any, maxBatchSize+1)
	for i := range batch {
		batch[i] = validPayload(fmt.Sprintf("e%d", i))
	}

	w := postListens(t, repo, user, batch)

	if w.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d", w.Code, http.StatusBadRequest)
	}
	if got := countEvents(t, repo); got != 0 {
		t.Fatalf("stored %d events from rejected batch, want 0", got)
	}
}

func TestPostListensRejectsMalformedBody(t *testing.T) {
	repo := newStatsRepo(t)
	user := &models.User{Model: gorm.Model{ID: 1}}

	w := postListens(t, repo, user, "not json")

	if w.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, want %d", w.Code, http.StatusBadRequest)
	}
}

func TestPostListensRequiresUser(t *testing.T) {
	repo := newStatsRepo(t)

	w := postListens(t, repo, nil, []map[string]any{validPayload("e1")})

	if w.Code != http.StatusUnauthorized {
		t.Fatalf("status = %d, want %d", w.Code, http.StatusUnauthorized)
	}
}

func TestGetListensPaginatesNewestFirstAcrossUsers(t *testing.T) {
	repo := newStatsRepo(t)

	alice := models.User{Email: "alice@example.com", FirebaseUID: "a", Role: "user"}
	bob := models.User{Email: "bob@example.com", FirebaseUID: "b", Role: "admin"}
	if err := repo.DB.Create(&alice).Error; err != nil {
		t.Fatalf("create alice: %v", err)
	}
	if err := repo.DB.Create(&bob).Error; err != nil {
		t.Fatalf("create bob: %v", err)
	}

	track := models.Track{Id: "track-uuid-1", Title: "Kolme toivetta", Artist: "KUUMAA"}
	if err := repo.DB.Create(&track).Error; err != nil {
		t.Fatalf("create track: %v", err)
	}

	for i := 0; i < 150; i++ {
		owner := alice.ID
		if i%2 == 0 {
			owner = bob.ID
		}
		event := models.ListenEvent{
			UserID:        owner,
			TrackID:       "track-uuid-1",
			DurationMs:    int64(10000 + i),
			StartedAt:     time.Now().UTC(),
			ClientEventID: fmt.Sprintf("e%d", i),
		}
		if err := repo.DB.Create(&event).Error; err != nil {
			t.Fatalf("seed event: %v", err)
		}
	}

	first := getListens(t, repo, "?page=1")
	if first.Total != 150 {
		t.Fatalf("total = %d, want 150", first.Total)
	}
	if len(first.Listens) != 100 {
		t.Fatalf("page 1 has %d listens, want 100", len(first.Listens))
	}
	if first.Listens[0].DurationMs != 10149 {
		t.Fatalf("first entry duration = %d, want newest (10149)", first.Listens[0].DurationMs)
	}
	if first.Listens[0].TrackTitle != "Kolme toivetta" || first.Listens[0].TrackArtist != "KUUMAA" {
		t.Fatalf("track info not joined: %+v", first.Listens[0])
	}

	second := getListens(t, repo, "?page=2")
	if len(second.Listens) != 50 {
		t.Fatalf("page 2 has %d listens, want 50", len(second.Listens))
	}
	if second.Listens[49].DurationMs != 10000 {
		t.Fatalf("last entry duration = %d, want oldest (10000)", second.Listens[49].DurationMs)
	}

	// Both users' listens present — endpoint must not filter by requester.
	emails := map[string]bool{}
	for _, l := range first.Listens {
		emails[l.UserEmail] = true
	}
	if !emails["alice@example.com"] || !emails["bob@example.com"] {
		t.Fatalf("expected listens from both users on page 1, got %v", emails)
	}
}

func TestGetListensClampsPageSizeAndHandlesMissingTrack(t *testing.T) {
	repo := newStatsRepo(t)
	user := models.User{Email: "u@example.com", FirebaseUID: "u", Role: "user"}
	if err := repo.DB.Create(&user).Error; err != nil {
		t.Fatalf("create user: %v", err)
	}
	for i := 0; i < 5; i++ {
		event := models.ListenEvent{
			UserID:        user.ID,
			TrackID:       "deleted-track",
			DurationMs:    10000,
			StartedAt:     time.Now().UTC(),
			ClientEventID: fmt.Sprintf("e%d", i),
		}
		if err := repo.DB.Create(&event).Error; err != nil {
			t.Fatalf("seed event: %v", err)
		}
	}

	page := getListens(t, repo, "?page=1&page_size=100000")
	if page.PageSize != maxListensPageSize {
		t.Fatalf("page_size = %d, want clamped to %d", page.PageSize, maxListensPageSize)
	}
	// Track no longer in library — entry still listed, title just empty.
	if page.Listens[0].TrackTitle != "" || page.Listens[0].TrackID != "deleted-track" {
		t.Fatalf("unexpected entry for missing track: %+v", page.Listens[0])
	}

	small := getListens(t, repo, "?page=1&page_size=2")
	if len(small.Listens) != 2 {
		t.Fatalf("got %d listens, want 2", len(small.Listens))
	}
}
