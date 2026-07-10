package musicbrainz

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	mbBaseURL  = "https://musicbrainz.org/ws/2"
	caaBaseURL = "https://coverartarchive.org"
	userAgent  = "BasementMusic/2.0.0 (+https://basement.madetara.dev)"

	// MusicBrainz enforces a hard 1 req/s limit; stay just under it.
	mbMinInterval = 1100 * time.Millisecond
)

type Client struct {
	http *http.Client

	mbMu   sync.Mutex
	lastMB time.Time
}

func NewClient() *Client {
	return &Client{
		http: &http.Client{Timeout: 15 * time.Second},
	}
}

// ArtistCandidate is a MusicBrainz artist search hit.
type ArtistCandidate struct {
	Id             string `json:"Id"`
	Name           string `json:"Name"`
	Disambiguation string `json:"Disambiguation"`
	Type           string `json:"Type"`
	Country        string `json:"Country"`
	Begin          string `json:"Begin"`
}

// ArtistDetails is the resolved metadata for one MBID.
type ArtistDetails struct {
	Description string
	ImageUrl    string
}

// ReleaseGroupCandidate is a MusicBrainz release-group hit with a CAA thumbnail.
type ReleaseGroupCandidate struct {
	Id       string `json:"Id"`
	Title    string `json:"Title"`
	Year     string `json:"Year"`
	CoverUrl string `json:"CoverUrl"`
}

// throttleMB blocks until at least mbMinInterval has elapsed since the previous
// MusicBrainz request, then reserves the slot. CAA/Wikipedia are unthrottled.
func (c *Client) throttleMB() {
	c.mbMu.Lock()
	defer c.mbMu.Unlock()
	wait := mbMinInterval - time.Since(c.lastMB)
	if wait > 0 {
		time.Sleep(wait)
	}
	c.lastMB = time.Now()
}

func (c *Client) getJSON(rawURL string, throttled bool, out interface{}) (int, error) {
	if throttled {
		c.throttleMB()
	}
	req, err := http.NewRequest(http.MethodGet, rawURL, nil)
	if err != nil {
		return 0, err
	}
	req.Header.Set("User-Agent", userAgent)
	req.Header.Set("Accept", "application/json")

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

// SearchArtists returns up to 8 artist candidates for a free-text query.
func (c *Client) SearchArtists(query string) ([]ArtistCandidate, error) {
	q := url.Values{}
	q.Set("query", query)
	q.Set("fmt", "json")
	q.Set("limit", "8")

	var body struct {
		Artists []struct {
			Id             string `json:"id"`
			Name           string `json:"name"`
			Disambiguation string `json:"disambiguation"`
			Type           string `json:"type"`
			Country        string `json:"country"`
			LifeSpan       struct {
				Begin string `json:"begin"`
			} `json:"life-span"`
		} `json:"artists"`
	}
	status, err := c.getJSON(mbBaseURL+"/artist?"+q.Encode(), true, &body)
	if err != nil {
		return nil, err
	}
	if status != http.StatusOK {
		return nil, fmt.Errorf("musicbrainz artist search returned status %d", status)
	}

	candidates := make([]ArtistCandidate, 0, len(body.Artists))
	for _, a := range body.Artists {
		candidates = append(candidates, ArtistCandidate{
			Id:             a.Id,
			Name:           a.Name,
			Disambiguation: a.Disambiguation,
			Type:           a.Type,
			Country:        a.Country,
			Begin:          a.LifeSpan.Begin,
		})
	}
	return candidates, nil
}

// GetArtistDetails resolves description + image for an MBID. Description comes
// from the linked Wikipedia summary, falling back to the MB annotation/
// disambiguation. Missing pieces are "" rather than errors.
func (c *Client) GetArtistDetails(mbid string) (ArtistDetails, error) {
	q := url.Values{}
	q.Set("fmt", "json")
	q.Set("inc", "url-rels+annotation")

	var body struct {
		Annotation     string `json:"annotation"`
		Disambiguation string `json:"disambiguation"`
		Relations      []struct {
			Type string `json:"type"`
			Url  struct {
				Resource string `json:"resource"`
			} `json:"url"`
		} `json:"relations"`
	}
	status, err := c.getJSON(mbBaseURL+"/artist/"+mbid+"?"+q.Encode(), true, &body)
	if err != nil {
		return ArtistDetails{}, err
	}
	if status != http.StatusOK {
		return ArtistDetails{}, fmt.Errorf("musicbrainz artist lookup returned status %d", status)
	}

	details := ArtistDetails{}

	var wikidataURL string
	for _, rel := range body.Relations {
		if rel.Type == "wikidata" {
			wikidataURL = rel.Url.Resource
			break
		}
	}
	if wikidataURL != "" {
		extract, imageURL := c.wikipediaSummary(wikidataURL)
		details.Description = extract
		details.ImageUrl = imageURL
	}

	if details.Description == "" {
		if body.Annotation != "" {
			details.Description = body.Annotation
		} else {
			details.Description = body.Disambiguation
		}
	}

	return details, nil
}

// wikipediaSummary walks Wikidata → enwiki title → Wikipedia REST summary and
// returns (extract, imageURL). Any missing hop yields empty strings, not errors.
func (c *Client) wikipediaSummary(wikidataURL string) (string, string) {
	entity := wikidataURL[strings.LastIndex(wikidataURL, "/")+1:]
	if entity == "" {
		return "", ""
	}

	var wd struct {
		Entities map[string]struct {
			Sitelinks map[string]struct {
				Title string `json:"title"`
			} `json:"sitelinks"`
		} `json:"entities"`
	}
	status, err := c.getJSON("https://www.wikidata.org/wiki/Special:EntityData/"+entity+".json", false, &wd)
	if err != nil || status != http.StatusOK {
		return "", ""
	}

	title := ""
	if e, ok := wd.Entities[entity]; ok {
		if sl, ok := e.Sitelinks["enwiki"]; ok {
			title = sl.Title
		}
	}
	if title == "" {
		return "", ""
	}

	var summary struct {
		Extract       string `json:"extract"`
		OriginalImage struct {
			Source string `json:"source"`
		} `json:"originalimage"`
	}
	status, err = c.getJSON("https://en.wikipedia.org/api/rest_v1/page/summary/"+url.PathEscape(title), false, &summary)
	if err != nil || status != http.StatusOK {
		return "", ""
	}
	return summary.Extract, summary.OriginalImage.Source
}

// SearchReleaseGroups returns release-group candidates for an artist+title,
// each carrying a public CAA thumbnail URL for preview.
func (c *Client) SearchReleaseGroups(artist, title string) ([]ReleaseGroupCandidate, error) {
	query := fmt.Sprintf(`releasegroup:"%s"`, title)
	if artist != "" {
		query += fmt.Sprintf(` AND artist:"%s"`, artist)
	}
	q := url.Values{}
	q.Set("query", query)
	q.Set("fmt", "json")
	q.Set("limit", "12")

	var body struct {
		ReleaseGroups []struct {
			Id           string `json:"id"`
			Title        string `json:"title"`
			FirstRelease string `json:"first-release-date"`
		} `json:"release-groups"`
	}
	status, err := c.getJSON(mbBaseURL+"/release-group?"+q.Encode(), true, &body)
	if err != nil {
		return nil, err
	}
	if status != http.StatusOK {
		return nil, fmt.Errorf("musicbrainz release-group search returned status %d", status)
	}

	candidates := make([]ReleaseGroupCandidate, 0, len(body.ReleaseGroups))
	for _, rg := range body.ReleaseGroups {
		year := ""
		if len(rg.FirstRelease) >= 4 {
			year = rg.FirstRelease[:4]
		}
		candidates = append(candidates, ReleaseGroupCandidate{
			Id:       rg.Id,
			Title:    rg.Title,
			Year:     year,
			CoverUrl: caaBaseURL + "/release-group/" + rg.Id + "/front-250",
		})
	}
	return candidates, nil
}

// CoverUrl builds the full-size CAA front cover URL for a release-group MBID.
func (c *Client) CoverUrl(mbid string) string {
	return caaBaseURL + "/release-group/" + mbid + "/front"
}

// DownloadImage fetches image bytes, following redirects. A 404 yields
// (nil, nil) so callers can treat "no image" as a non-error.
func (c *Client) DownloadImage(rawURL string) ([]byte, error) {
	req, err := http.NewRequest(http.MethodGet, rawURL, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", userAgent)

	resp, err := c.http.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, nil
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("image download returned status %d", resp.StatusCode)
	}
	return io.ReadAll(resp.Body)
}
