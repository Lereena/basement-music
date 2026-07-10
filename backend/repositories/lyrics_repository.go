package repositories

import (
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/bogem/id3v2/v2"
	"github.com/gorilla/mux"
	"gorm.io/gorm"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/lrclib"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
)

// USLT (Unsynchronised lyrics/text transcription) frame description.
const usltFrameDescription = "Unsynchronised lyrics/text transcription"

// Matches LRC timestamp lines like [01:23.45] / [1:23] to distinguish synced
// (LRC) lyrics from plain text stored in the same USLT frame.
var lrcTimestampRe = regexp.MustCompile(`(?m)^\s*\[\d{1,2}:\d{2}(?:[.:]\d{1,3})?\]`)

type LyricsRepository struct {
	DB     *gorm.DB
	Cfg    *config.Config
	Lrclib *lrclib.Client
}

func isMp3(track models.Track) bool {
	return strings.EqualFold(filepath.Ext(track.Url), ".mp3")
}

func (repo *LyricsRepository) trackPath(track models.Track) string {
	return filepath.Join(repo.Cfg.MusicPath, track.Url)
}

func (repo *LyricsRepository) findTrack(id string) (models.Track, bool) {
	var track models.Track
	repo.DB.Where(&models.Track{Id: id}).First(&track)
	return track, track.Id != ""
}

// readUSLT returns the first non-empty USLT frame text, or "" if none.
func readUSLT(path string) (string, error) {
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true, ParseFrames: []string{"USLT"}})
	if err != nil {
		return "", err
	}
	defer tag.Close()

	for _, frame := range tag.GetFrames(tag.CommonID(usltFrameDescription)) {
		if uslt, ok := frame.(id3v2.UnsynchronisedLyricsFrame); ok && strings.TrimSpace(uslt.Lyrics) != "" {
			return uslt.Lyrics, nil
		}
	}
	return "", nil
}

// writeUSLT replaces the USLT frame with lyrics. Opens with a full parse so
// Save() preserves all existing frames. Save() writes a temp file and renames
// it over the original, so concurrent http.ServeFile readers keep the old inode.
func writeUSLT(path, lyrics string) error {
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true})
	if err != nil {
		return err
	}
	defer tag.Close()

	tag.DeleteFrames(tag.CommonID(usltFrameDescription))
	tag.AddUnsynchronisedLyricsFrame(id3v2.UnsynchronisedLyricsFrame{
		Encoding:          id3v2.EncodingUTF8,
		Language:          "und", // ISO 639-2, must be exactly 3 bytes
		ContentDescriptor: "",
		Lyrics:            lyrics,
	})
	return tag.Save()
}

func fileLyricsResponse(track models.Track, text string) lrclib.Lyrics {
	duration := float64(track.Duration)
	response := lrclib.Lyrics{
		Id:         0,
		TrackName:  track.Title,
		ArtistName: track.Artist,
		Duration:   &duration,
	}
	if lrcTimestampRe.MatchString(text) {
		response.SyncedLyrics = &text
	} else {
		response.PlainLyrics = &text
	}
	return response
}

// GetFileLyrics reads embedded lyrics from the track's file.
// GET /api/track/{id}/lyrics/file
func (repo *LyricsRepository) GetFileLyrics(w http.ResponseWriter, r *http.Request) {
	track, ok := repo.findTrack(mux.Vars(r)["id"])
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}
	if !isMp3(track) {
		respond.RespondError(w, http.StatusNotFound, "No lyrics in file")
		return
	}

	text, err := readUSLT(repo.trackPath(track))
	if err != nil || strings.TrimSpace(text) == "" {
		respond.RespondError(w, http.StatusNotFound, "No lyrics in file")
		return
	}

	respond.RespondJSON(w, http.StatusOK, fileLyricsResponse(track, text))
}

// SearchLyrics proxies lrclib.net.
// GET /api/track/{id}/lyrics/search
func (repo *LyricsRepository) SearchLyrics(w http.ResponseWriter, r *http.Request) {
	track, ok := repo.findTrack(mux.Vars(r)["id"])
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}

	lyrics, err := repo.Lrclib.Find(track.Artist, track.Title, track.Duration)
	if err != nil {
		respond.RespondError(w, http.StatusBadGateway, "Lyrics provider unavailable")
		return
	}
	if lyrics == nil {
		respond.RespondError(w, http.StatusNotFound, "No lyrics found")
		return
	}

	respond.RespondJSON(w, http.StatusOK, lyrics)
}

// SaveLyrics embeds lyrics into the track's file, transcoding non-mp3 to mp3
// first, and marks the track lyrics-having.
// POST /api/track/{id}/lyrics  form: lyrics
func (repo *LyricsRepository) SaveLyrics(w http.ResponseWriter, r *http.Request) {
	lyrics := strings.TrimSpace(r.FormValue("lyrics"))
	if lyrics == "" {
		respond.RespondError(w, http.StatusBadRequest, "lyrics is empty")
		return
	}

	track, ok := repo.findTrack(mux.Vars(r)["id"])
	if !ok {
		respond.RespondError(w, http.StatusNotFound, "Track not found")
		return
	}

	updates := map[string]any{"has_lyrics": true}

	if isMp3(track) {
		if err := writeUSLT(repo.trackPath(track), lyrics); err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "Failed to write lyrics")
			return
		}
	} else {
		newURL, err := repo.transcodeAndEmbed(track, lyrics)
		if err != nil {
			respond.RespondError(w, http.StatusInternalServerError, "Failed to transcode and write lyrics")
			return
		}
		updates["url"] = newURL
		track.Url = newURL
	}

	repo.DB.Model(&models.Track{}).Where(&models.Track{Id: track.Id}).Updates(updates)
	track.HasLyrics = true

	respond.RespondJSON(w, http.StatusOK, track)
}

// transcodeAndEmbed converts a non-mp3 track to mp3, embeds the lyrics, swaps
// the file in place, and returns the new filename. The new file is fully
// written before the old one is removed so the track never points at nothing.
func (repo *LyricsRepository) transcodeAndEmbed(track models.Track, lyrics string) (string, error) {
	oldPath := repo.trackPath(track)
	newURL := strings.TrimSuffix(track.Url, filepath.Ext(track.Url)) + ".mp3"
	newPath := filepath.Join(repo.Cfg.MusicPath, newURL)

	// Transcode into a temp file first so a failure leaves the original intact.
	tempPath := newPath + ".tmp"
	cmd := exec.Command("ffmpeg", "-i", oldPath, "-codec:a", "libmp3lame", "-q:a", "2", "-y", tempPath)
	if err := cmd.Run(); err != nil {
		os.Remove(tempPath)
		return "", err
	}

	if err := writeUSLT(tempPath, lyrics); err != nil {
		os.Remove(tempPath)
		return "", err
	}

	if err := os.Rename(tempPath, newPath); err != nil {
		os.Remove(tempPath)
		return "", err
	}

	// Remove the original only if it wasn't just overwritten (e.g. .MP3 vs .mp3
	// on a case-insensitive FS would collide — skip removal when paths match).
	if oldPath != newPath {
		os.Remove(oldPath)
	}

	return newURL, nil
}
