package lrclib

import (
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"time"
)

const (
	baseURL   = "https://lrclib.net"
	userAgent = "BasementMusic/2.0.0 (+https://basement.madetara.dev)"
)

// Lyrics mirrors the lrclib.net response shape. JSON tags are camelCase so the
// frontend's existing Lyrics model decodes it unchanged.
type Lyrics struct {
	Id           int64    `json:"id"`
	TrackName    string   `json:"trackName"`
	ArtistName   string   `json:"artistName"`
	Instrumental bool     `json:"instrumental"`
	Duration     *float64 `json:"duration"`
	PlainLyrics  *string  `json:"plainLyrics"`
	SyncedLyrics *string  `json:"syncedLyrics"`
}

func (l *Lyrics) HasSynced() bool {
	return l.SyncedLyrics != nil && strings.TrimSpace(*l.SyncedLyrics) != ""
}

func (l *Lyrics) hasPlain() bool {
	return l.PlainLyrics != nil && strings.TrimSpace(*l.PlainLyrics) != ""
}

func (l *Lyrics) IsEmpty() bool {
	return !l.HasSynced() && !l.hasPlain() && !l.Instrumental
}

type Client struct {
	http    *http.Client
	baseURL string
}

func NewClient() *Client {
	return &Client{
		http:    &http.Client{Timeout: 15 * time.Second},
		baseURL: baseURL,
	}
}

// Find returns (nil, nil) when nothing matches.
func (c *Client) Find(artist, title string, duration int) (*Lyrics, error) {
	query := url.Values{}
	query.Set("artist_name", artist)
	query.Set("track_name", title)
	query.Set("duration", strconv.Itoa(duration))

	var lyrics Lyrics
	status, err := c.get("/api/get?"+query.Encode(), &lyrics)
	if err != nil {
		return nil, err
	}
	if status == http.StatusOK {
		return &lyrics, nil
	}
	if status == http.StatusNotFound {
		return c.search(artist, title, duration)
	}
	return nil, fmt.Errorf("lrclib /api/get returned status %d", status)
}

func (c *Client) search(artist, title string, duration int) (*Lyrics, error) {
	query := url.Values{}
	query.Set("track_name", title)
	query.Set("artist_name", artist)

	var results []Lyrics
	status, err := c.get("/api/search?"+query.Encode(), &results)
	if err != nil {
		return nil, err
	}
	if status != http.StatusOK {
		return nil, nil
	}

	filtered := results[:0]
	for _, lyrics := range results {
		if !lyrics.IsEmpty() {
			filtered = append(filtered, lyrics)
		}
	}
	if len(filtered) == 0 {
		return nil, nil
	}

	score := func(l *Lyrics) int {
		result := 0
		if l.Duration != nil && math.Abs(*l.Duration-float64(duration)) <= 3 {
			result += 2
		}
		if l.HasSynced() {
			result++
		}
		return result
	}
	sort.SliceStable(filtered, func(i, j int) bool {
		return score(&filtered[i]) > score(&filtered[j])
	})

	best := filtered[0]
	return &best, nil
}

// get issues a GET and decodes a 200 body into out. Non-200 responses are
// returned as a status code without decoding (out is left untouched).
func (c *Client) get(path string, out interface{}) (int, error) {
	req, err := http.NewRequest(http.MethodGet, c.baseURL+path, nil)
	if err != nil {
		return 0, err
	}
	req.Header.Set("User-Agent", userAgent)

	resp, err := c.http.Do(req)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return resp.StatusCode, nil
	}
	if err := json.NewDecoder(resp.Body).Decode(out); err != nil {
		return resp.StatusCode, err
	}
	return resp.StatusCode, nil
}
