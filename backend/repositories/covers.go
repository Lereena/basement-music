package repositories

import (
	"bytes"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/bogem/id3v2/v2"
	"github.com/gorilla/mux"

	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
)

// APIC (Attached picture) frame description.
const apicFrameDescription = "Attached picture"

func albumCoverURL(albumId string) string { return "/api/album/" + albumId + "/image" }
func trackCoverURL(trackId string) string { return "/api/track/" + trackId + "/cover" }

// readAPIC returns the first embedded picture and its MIME type, or nil if none.
func readAPIC(path string) ([]byte, string, error) {
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true, ParseFrames: []string{"APIC"}})
	if err != nil {
		return nil, "", err
	}
	defer tag.Close()

	for _, frame := range tag.GetFrames(tag.CommonID(apicFrameDescription)) {
		if pic, ok := frame.(id3v2.PictureFrame); ok && len(pic.Picture) > 0 {
			return pic.Picture, pic.MimeType, nil
		}
	}
	return nil, "", nil
}

// writeAPIC replaces the embedded picture with image. Opens with a full parse
// so Save() preserves all existing frames (same approach as writeUSLT).
func writeAPIC(path string, image []byte) error {
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true})
	if err != nil {
		return err
	}
	defer tag.Close()

	tag.DeleteFrames(tag.CommonID(apicFrameDescription))
	tag.AddAttachedPicture(id3v2.PictureFrame{
		Encoding:    id3v2.EncodingUTF8,
		MimeType:    http.DetectContentType(image),
		PictureType: id3v2.PTFrontCover,
		Description: "Front cover",
		Picture:     image,
	})
	return tag.Save()
}

// GetTrackCover serves the cover embedded in the track file's APIC frame.
// GET /api/track/{id}/cover
func (repo *TracksRepository) GetTrackCover(w http.ResponseWriter, r *http.Request) {
	var track models.Track
	repo.DB.Where(&models.Track{Id: mux.Vars(r)["id"]}).First(&track)
	if track.Id == "" || !isMp3(track) {
		respond.RespondError(w, http.StatusNotFound, "No cover in file")
		return
	}

	image, mimeType, err := readAPIC(filepath.Join(repo.Cfg.MusicPath, track.Url))
	if err != nil || len(image) == 0 {
		respond.RespondError(w, http.StatusNotFound, "No cover in file")
		return
	}

	w.Header().Set("Content-Type", mimeType)
	w.Header().Set("Cache-Control", "public, max-age=31536000, immutable")
	w.Write(image)
}

// BackfillCoverFromFile points the track's cover at its embedded picture when
// the file already carries one and the track has no cover yet. Used on scan so
// covers present in file metadata show up without any album binding.
func (repo *TracksRepository) BackfillCoverFromFile(trackId string) {
	var track models.Track
	if err := repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error; err != nil {
		return
	}
	if track.Cover != "" || !isMp3(track) {
		return
	}

	image, _, err := readAPIC(filepath.Join(repo.Cfg.MusicPath, track.Url))
	if err != nil || len(image) == 0 {
		return
	}

	repo.DB.Model(&models.Track{}).Where("id = ?", track.Id).Update("cover", trackCoverURL(track.Id))
}

// SyncAlbumCoverToTracks embeds the album's image into every track of the
// album and points each track's cover at it. No-op if the album has no image.
func (repo *AlbumsRepository) SyncAlbumCoverToTracks(albumId string) {
	image, err := os.ReadFile(filepath.Join(repo.imagesDir(), albumId))
	if err != nil {
		return
	}

	var tracks []models.Track
	repo.DB.Where("album_id = ?", albumId).Find(&tracks)
	for _, track := range tracks {
		repo.syncCoverToTrack(track, albumId, image)
	}
}

// SyncAlbumCoverToTrack does the same for a single track after it was bound.
// No-op if the track has no album or the album has no image.
func (repo *AlbumsRepository) SyncAlbumCoverToTrack(trackId string) {
	var track models.Track
	if err := repo.DB.Where(&models.Track{Id: trackId}).First(&track).Error; err != nil {
		return
	}
	if track.AlbumId == nil {
		return
	}

	image, err := os.ReadFile(filepath.Join(repo.imagesDir(), *track.AlbumId))
	if err != nil {
		return
	}

	repo.syncCoverToTrack(track, *track.AlbumId, image)
}

// syncCoverToTrack embeds image into the track's file (mp3 only; other formats
// fall back to the album image URL) and updates the track's cover. Skips the
// file write when the same image is already embedded so rescans don't rewrite
// files or bump updated_at (which would bust client image caches for nothing).
func (repo *AlbumsRepository) syncCoverToTrack(track models.Track, albumId string, image []byte) {
	cover := albumCoverURL(albumId)
	embeddedChanged := false

	if isMp3(track) {
		path := filepath.Join(repo.Cfg.MusicPath, track.Url)
		existing, _, _ := readAPIC(path)
		if bytes.Equal(existing, image) {
			cover = trackCoverURL(track.Id)
		} else if err := writeAPIC(path, image); err == nil {
			cover = trackCoverURL(track.Id)
			embeddedChanged = true
		} else {
			log.Printf("Failed to embed cover into %s: %v", track.Url, err)
		}
	}

	if embeddedChanged || track.Cover != cover {
		repo.DB.Model(&models.Track{}).Where("id = ?", track.Id).Update("cover", cover)
	}
}
