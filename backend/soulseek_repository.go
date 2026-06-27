package main

import (
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/repositories"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

const defaultDisconnectAfterMinutes = 10

type SoulseekRepository struct {
	DB          *gorm.DB
	Cfg         *config.Config
	Worker      *SoulseekWorker
	musicRepo   *repositories.TracksRepository
	artistsRepo *repositories.ArtistsRepository
}

// loadIdleMinutes returns the configured idle-disconnect window in minutes,
// falling back to the default when no row exists.
func (repo *SoulseekRepository) loadIdleMinutes() int {
	var settings models.SoulseekSettings
	if err := repo.DB.First(&settings).Error; err != nil {
		return defaultDisconnectAfterMinutes
	}
	return settings.DisconnectAfterMinutes
}

// loadCredentials returns the stored Soulseek credentials with the password decrypted.
func (repo *SoulseekRepository) loadCredentials() (models.SoulseekCredentials, bool) {
	var creds models.SoulseekCredentials
	err := repo.DB.Order("created_at DESC").First(&creds).Error
	if err != nil {
		return creds, false
	}
	password, err := config.Decrypt(creds.Password)
	if err != nil {
		log.Printf("Failed to decrypt Soulseek credentials: %v", err)
		return creds, false
	}
	creds.Password = password
	return creds, true
}

// connectionPayload is the shared shape for connection-state responses.
func connectionPayload(state ConnState, username, reason string) map[string]any {
	return map[string]any{"state": string(state), "username": username, "reason": reason}
}

// triggerConnect starts a background connect from stored credentials and returns
// the resulting connection state. Reports failed when prerequisites are missing.
func (repo *SoulseekRepository) triggerConnect() (ConnState, string) {
	if !config.SecretConfigured() {
		return StateFailed, "SLSK_SECRET not configured"
	}
	creds, ok := repo.loadCredentials()
	if !ok {
		return StateFailed, "no stored Soulseek credentials"
	}
	return repo.Worker.EnsureConnecting(creds.Username, creds.Password), ""
}

// Connect applies the idle-disconnect setting, starts the idle monitor, and
// connects the daemon using stored credentials, if any. Called on startup.
func (repo *SoulseekRepository) Connect() {
	repo.Worker.SetIdleWindow(time.Duration(repo.loadIdleMinutes()) * time.Minute)
	repo.Worker.StartIdleMonitor()

	creds, ok := repo.loadCredentials()
	if !ok {
		return
	}
	if err := repo.Worker.Start(creds.Username, creds.Password); err != nil {
		log.Printf("Soulseek startup connect failed: %v", err)
	}
}

// POST /api/admin/soulseek/credentials
func (repo *SoulseekRepository) SetCredentials(w http.ResponseWriter, r *http.Request) {
	username := strings.TrimSpace(r.FormValue("username"))
	password := r.FormValue("password")
	if username == "" || password == "" {
		respond.RespondError(w, http.StatusBadRequest, "username and password required")
		return
	}

	if !config.SecretConfigured() {
		respond.RespondError(w, http.StatusInternalServerError, "SLSK_SECRET not configured")
		return
	}

	encrypted, err := config.Encrypt(password)
	if err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to encrypt credentials")
		return
	}

	// Keep exactly one credentials row: update in place if present, else create.
	// Use the same ordering as loadCredentials so we operate on the same row.
	var creds models.SoulseekCredentials
	if err := repo.DB.Order("created_at DESC").First(&creds).Error; err != nil {
		creds = models.SoulseekCredentials{Username: username, Password: encrypted}
		if err := repo.DB.Create(&creds).Error; err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "failed to save credentials")
			return
		}
	} else {
		creds.Username = username
		creds.Password = encrypted
		if err := repo.DB.Save(&creds).Error; err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "failed to save credentials")
			return
		}
	}

	if err := repo.Worker.Start(username, password); err != nil {
		respond.RespondError(w, http.StatusBadGateway, "saved, but failed to connect: "+err.Error())
		return
	}

	respond.RespondJSON(w, http.StatusOK, map[string]any{"connected": true, "username": username})
}

// GET /api/admin/soulseek/status
func (repo *SoulseekRepository) GetStatus(w http.ResponseWriter, r *http.Request) {
	connected, username := repo.Worker.Status()
	respond.RespondJSON(w, http.StatusOK, map[string]any{"connected": connected, "username": username})
}

// POST /api/admin/soulseek/disconnect
func (repo *SoulseekRepository) Disconnect(w http.ResponseWriter, r *http.Request) {
	repo.Worker.Stop()
	w.WriteHeader(http.StatusNoContent)
}

// GET /api/soulseek/search?q=...
func (repo *SoulseekRepository) Search(w http.ResponseWriter, r *http.Request) {
	query := strings.TrimSpace(r.URL.Query().Get("q"))
	if query == "" {
		respond.RespondError(w, http.StatusBadRequest, "query required")
		return
	}

	// If not connected, kick off a background connect and tell the client to wait.
	state, _, username := repo.Worker.ConnectionState()
	if state != StateConnected {
		newState, reason := repo.triggerConnect()
		respond.RespondJSON(w, http.StatusServiceUnavailable, connectionPayload(newState, username, reason))
		return
	}

	repo.Worker.MarkUsage()
	results, err := repo.Worker.Search(query)
	if err != nil {
		// Daemon may have died mid-request -- reconnect in the background and ask
		// the client to retry once we're up again.
		newState, reason := repo.triggerConnect()
		respond.RespondJSON(w, http.StatusServiceUnavailable, connectionPayload(newState, username, reason))
		return
	}

	sortResults(results)
	respond.RespondJSON(w, http.StatusOK, results)
}

// GET /api/soulseek/connection
func (repo *SoulseekRepository) GetConnection(w http.ResponseWriter, r *http.Request) {
	state, reason, username := repo.Worker.ConnectionState()
	respond.RespondJSON(w, http.StatusOK, connectionPayload(state, username, reason))
}

// GET /api/admin/soulseek/settings
func (repo *SoulseekRepository) GetSettings(w http.ResponseWriter, r *http.Request) {
	respond.RespondJSON(w, http.StatusOK, map[string]any{
		"disconnect_after_minutes": repo.loadIdleMinutes(),
	})
}

// POST /api/admin/soulseek/settings  body: {minutes}
func (repo *SoulseekRepository) SetSettings(w http.ResponseWriter, r *http.Request) {
	minutes, err := strconv.Atoi(strings.TrimSpace(r.FormValue("minutes")))
	if err != nil || minutes < 0 {
		respond.RespondError(w, http.StatusBadRequest, "minutes must be a non-negative integer")
		return
	}

	// Keep exactly one settings row.
	var settings models.SoulseekSettings
	if err := repo.DB.First(&settings).Error; err != nil {
		settings = models.SoulseekSettings{DisconnectAfterMinutes: minutes}
		if err := repo.DB.Create(&settings).Error; err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "failed to save settings")
			return
		}
	} else {
		settings.DisconnectAfterMinutes = minutes
		if err := repo.DB.Save(&settings).Error; err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "failed to save settings")
			return
		}
	}

	repo.Worker.SetIdleWindow(time.Duration(minutes) * time.Minute)
	respond.RespondJSON(w, http.StatusOK, map[string]any{"disconnect_after_minutes": minutes})
}

// POST /api/soulseek/preload  body: {username, filename}
func (repo *SoulseekRepository) Preload(w http.ResponseWriter, r *http.Request) {
	peer := strings.TrimSpace(r.FormValue("username"))
	filename := r.FormValue("filename")
	if peer == "" || filename == "" {
		respond.RespondError(w, http.StatusBadRequest, "username and filename required")
		return
	}

	if state, _, _ := repo.Worker.ConnectionState(); state != StateConnected {
		respond.RespondError(w, http.StatusServiceUnavailable, "Soulseek not connected")
		return
	}
	repo.Worker.MarkUsage()

	id := uuid.New().String()
	ext := filepath.Ext(filename)
	if ext == "" {
		ext = ".mp3"
	}
	outPath := filepath.Join(repo.Worker.tempDir(), id+ext)

	if err := repo.Worker.Download(peer, filename, outPath); err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Peer refused — try another: "+err.Error())
		return
	}

	// Transcode non-MP3 formats (e.g. FLAC) to MP3 so iOS AVPlayer can stream it.
	if !strings.EqualFold(ext, ".mp3") {
		mp3Path := filepath.Join(repo.Worker.tempDir(), id+".mp3")
		cmd := exec.Command("ffmpeg", "-i", outPath, "-codec:a", "libmp3lame", "-q:a", "2", "-y", mp3Path)
		if err := cmd.Run(); err == nil {
			os.Remove(outPath)
			outPath = mp3Path
			ext = ".mp3"
		} else {
			log.Printf("ffmpeg transcode failed, serving original: %v", err)
		}
	}

	artist, title := parseSoulseekFilename(filename)
	relPath := filepath.Join(tempDirName, id+ext)
	duration := repo.Cfg.GetTrackDuration(relPath)

	temp := TempTrack{ID: id, Path: outPath, Artist: artist, Title: title, Duration: duration}
	repo.Worker.AddTemp(temp)

	respond.RespondJSON(w, http.StatusOK, temp)
}

// GET /api/soulseek/temp/{id}
func (repo *SoulseekRepository) ServeTemp(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	temp, ok := repo.Worker.GetTemp(id)
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "temp track not found")
		return
	}
	http.ServeFile(w, r, temp.Path)
}

// POST /api/soulseek/save  body: {id}
func (repo *SoulseekRepository) SaveTrack(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimSpace(r.FormValue("id"))
	if id == "" {
		respond.RespondError(w, http.StatusBadRequest, "id required")
		return
	}

	temp, ok := repo.Worker.GetTemp(id)
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "temp track not found")
		return
	}
	repo.Worker.MarkUsage()

	// Client may override the server-parsed artist/title via the edit dialog.
	if artist := strings.TrimSpace(r.FormValue("artist")); artist != "" {
		temp.Artist = artist
	}
	if title := strings.TrimSpace(r.FormValue("title")); title != "" {
		temp.Title = title
	}

	ext := filepath.Ext(temp.Path)
	trackFileName := temp.Artist + " - " + temp.Title + ext
	permanentPath := filepath.Join(repo.Cfg.MusicPath, trackFileName)

	if err := os.Rename(temp.Path, permanentPath); err != nil {
		respond.RespondError(w, http.StatusInternalServerError, "failed to move track")
		return
	}

	trackId := repo.musicRepo.CreateTrack(temp.Artist, temp.Title, temp.Duration, trackFileName, "")

	for _, name := range strings.Split(temp.Artist, ",") {
		name = strings.TrimSpace(name)
		if name == "" {
			continue
		}
		artistId := repo.artistsRepo.CreateArtist(name)
		if err := repo.artistsRepo.AssociateTrackWithArtist(artistId, trackId); err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}

	repo.Worker.RemoveTemp(id)
	repo.Worker.RefreshShares()

	var track models.Track
	repo.DB.Where(&models.Track{Id: trackId}).First(&track)
	respond.RespondJSON(w, http.StatusOK, track)
}

// DELETE /api/soulseek/temp
func (repo *SoulseekRepository) CleanupSession(w http.ResponseWriter, r *http.Request) {
	repo.Worker.CleanupTemp()
	w.WriteHeader(http.StatusNoContent)
}

// sortResults orders results best-first: FLAC bonus + bitrate + free slots + speed.
func sortResults(results []SearchResult) {
	score := func(r SearchResult) int {
		s := r.Bitrate + r.Speed/1000
		if strings.EqualFold(r.Extension, "flac") {
			s += 2000
		}
		if r.FreeSlots {
			s += 500
		}
		return s
	}
	sort.SliceStable(results, func(i, j int) bool {
		return score(results[i]) > score(results[j])
	})
}

var slskSplitRegexp = regexp.MustCompile(splitSymbols)

// parseSoulseekFilename extracts (artist, title) from a remote Soulseek path.
func parseSoulseekFilename(remotePath string) (string, string) {
	// take the base name, strip directory and extension
	base := remotePath
	if idx := strings.LastIndexAny(base, "/\\"); idx >= 0 {
		base = base[idx+1:]
	}
	if idx := strings.LastIndex(base, "."); idx > 0 {
		base = base[:idx]
	}

	parts := slskSplitRegexp.Split(base, -1)
	if len(parts) >= 2 {
		return strings.TrimSpace(parts[0]), strings.TrimSpace(parts[1])
	}
	return "", strings.TrimSpace(base)
}
