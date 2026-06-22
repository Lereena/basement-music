package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
	"time"

	"github.com/Lereena/server_basement_music/config"
)

const (
	daemonPort   = "19876"
	daemonScript = "soulseek_daemon.py"
	tempDirName  = "slsk_temp"
)

// TempTrack is a previewed (downloaded-to-temp) track not yet saved to the library.
type TempTrack struct {
	ID       string `json:"id"`
	Path     string `json:"-"`
	Artist   string `json:"artist"`
	Title    string `json:"title"`
	Duration int    `json:"duration"`
}

// SearchResult is a flat per-file entry returned by the daemon (one per file per peer).
type SearchResult struct {
	PeerUsername string `json:"username"`
	Filename     string `json:"filename"`
	Extension    string `json:"extension"`
	Bitrate      int    `json:"bitrate"`
	Size         int64  `json:"size"`
	FreeSlots    bool   `json:"free_slots"`
	Speed        int    `json:"speed"`
}

// SoulseekWorker manages the Python daemon process and proxies HTTP to it.
type SoulseekWorker struct {
	cmd        *exec.Cmd
	httpClient *http.Client
	daemonURL  string
	tempTracks map[string]TempTrack
	mu         sync.Mutex
	Cfg        *config.Config
}

func NewSoulseekWorker(cfg *config.Config) *SoulseekWorker {
	return &SoulseekWorker{
		httpClient: &http.Client{Timeout: 60 * time.Second},
		daemonURL:  "http://127.0.0.1:" + daemonPort,
		tempTracks: make(map[string]TempTrack),
		Cfg:        cfg,
	}
}

func (sw *SoulseekWorker) tempDir() string {
	return filepath.Join(sw.Cfg.MusicPath, tempDirName)
}

// Start launches the daemon process with the given credentials and waits until
// it reports connected. If a daemon is already running it is stopped first.
func (sw *SoulseekWorker) Start(username, password string) error {
	sw.Stop()

	if err := os.MkdirAll(sw.tempDir(), 0755); err != nil {
		return fmt.Errorf("create temp dir: %w", err)
	}

	cmd := exec.Command("python3", daemonScript)
	cmd.Env = append(os.Environ(),
		"SLSK_USERNAME="+username,
		"SLSK_PASSWORD="+password,
		"MUSIC_PATH="+sw.Cfg.MusicPath,
		"SLSK_PORT="+daemonPort,
	)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Start(); err != nil {
		return fmt.Errorf("start daemon: %w", err)
	}

	sw.mu.Lock()
	sw.cmd = cmd
	sw.mu.Unlock()

	// Poll /status until connected (or timeout).
	deadline := time.Now().Add(45 * time.Second)
	for time.Now().Before(deadline) {
		if connected, _, err := sw.status(); err == nil && connected {
			log.Println("Soulseek daemon connected")
			return nil
		}
		time.Sleep(time.Second)
	}
	sw.Stop()
	return fmt.Errorf("daemon did not connect within timeout")
}

// Stop kills the daemon process if running.
func (sw *SoulseekWorker) Stop() {
	sw.mu.Lock()
	cmd := sw.cmd
	sw.cmd = nil
	sw.mu.Unlock()

	if cmd != nil && cmd.Process != nil {
		_ = cmd.Process.Kill()
		_, _ = cmd.Process.Wait()
	}
}

// IsAlive reports whether the daemon process is running and the HTTP API responds.
func (sw *SoulseekWorker) IsAlive() bool {
	sw.mu.Lock()
	running := sw.cmd != nil
	sw.mu.Unlock()
	if !running {
		return false
	}
	_, _, err := sw.status()
	return err == nil
}

func (sw *SoulseekWorker) status() (connected bool, username string, err error) {
	resp, err := sw.httpClient.Get(sw.daemonURL + "/status")
	if err != nil {
		return false, "", err
	}
	defer resp.Body.Close()

	var body struct {
		Connected bool   `json:"connected"`
		Username  string `json:"username"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&body); err != nil {
		return false, "", err
	}
	return body.Connected, body.Username, nil
}

// Status returns the daemon connection state.
func (sw *SoulseekWorker) Status() (connected bool, username string) {
	c, u, err := sw.status()
	if err != nil {
		return false, ""
	}
	return c, u
}

// Search proxies a search request to the daemon and returns a flat result list.
func (sw *SoulseekWorker) Search(query string) ([]SearchResult, error) {
	payload, _ := json.Marshal(map[string]string{"query": query})
	resp, err := sw.httpClient.Post(sw.daemonURL+"/search", "application/json", bytes.NewReader(payload))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("daemon search returned %d", resp.StatusCode)
	}

	var results []SearchResult
	if err := json.NewDecoder(resp.Body).Decode(&results); err != nil {
		return nil, err
	}
	return results, nil
}

// Download asks the daemon to download exactly (peer, filename) to outPath.
// Returns an error (with the peer's reason) if the peer rejects -- no fallback.
func (sw *SoulseekWorker) Download(peer, filename, outPath string) error {
	payload, _ := json.Marshal(map[string]string{
		"username": peer,
		"filename": filename,
		"output":   outPath,
	})
	resp, err := sw.httpClient.Post(sw.daemonURL+"/download", "application/json", bytes.NewReader(payload))
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		var body struct {
			Error string `json:"error"`
		}
		_ = json.NewDecoder(resp.Body).Decode(&body)
		if body.Error == "" {
			body.Error = fmt.Sprintf("daemon returned %d", resp.StatusCode)
		}
		return fmt.Errorf("%s", body.Error)
	}
	return nil
}

// RefreshShares tells the daemon to re-scan the music directory (after SaveTrack).
func (sw *SoulseekWorker) RefreshShares() {
	resp, err := sw.httpClient.Post(sw.daemonURL+"/refresh-shares", "application/json", nil)
	if err != nil {
		log.Printf("RefreshShares failed: %v", err)
		return
	}
	defer resp.Body.Close()
	_, _ = io.Copy(io.Discard, resp.Body)
}

// AddTemp records a downloaded temp track in the in-memory map.
func (sw *SoulseekWorker) AddTemp(t TempTrack) {
	sw.mu.Lock()
	defer sw.mu.Unlock()
	sw.tempTracks[t.ID] = t
}

// GetTemp returns a temp track by id.
func (sw *SoulseekWorker) GetTemp(id string) (TempTrack, bool) {
	sw.mu.Lock()
	defer sw.mu.Unlock()
	t, ok := sw.tempTracks[id]
	return t, ok
}

// RemoveTemp removes a temp track from the map (without deleting the file).
func (sw *SoulseekWorker) RemoveTemp(id string) {
	sw.mu.Lock()
	defer sw.mu.Unlock()
	delete(sw.tempTracks, id)
}

// CleanupTemp deletes all temp files and clears the in-memory map.
func (sw *SoulseekWorker) CleanupTemp() {
	sw.mu.Lock()
	tracks := sw.tempTracks
	sw.tempTracks = make(map[string]TempTrack)
	sw.mu.Unlock()

	for _, t := range tracks {
		if err := os.Remove(t.Path); err != nil && !os.IsNotExist(err) {
			log.Printf("Failed to remove temp file %s: %v", t.Path, err)
		}
	}
}
