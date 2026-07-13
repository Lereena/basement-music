package repositories

import (
	"bytes"
	"image"
	_ "image/gif"
	"image/jpeg"
	_ "image/png"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/bogem/id3v2/v2"
	"github.com/gorilla/mux"
	xdraw "golang.org/x/image/draw"

	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
)

// APIC (Attached picture) frame description.
const apicFrameDescription = "Attached picture"

// maxCoverBytes bounds the encoded size of a cover before it is embedded into a
// track file. The cover is front-loaded into the mp3's ID3 tag ahead of the
// audio, so a large image pushes the first MPEG audio frame past the byte window
// browsers probe when opening the stream. ffmpeg (used by audioplayers on web)
// then fails with DEMUXER_ERROR_COULD_NOT_OPEN and the track won't play, even
// though native mobile players — which parse the whole tag — tolerate it. This
// is a byte budget on purpose: the bug is about bytes ahead of the audio, not
// pixels. 128 KiB keeps roughly a 2x margin under the ~256 KiB probe window
// observed to work.
const maxCoverBytes = 128 * 1024

// coverEdgeCeiling caps the starting longest edge so an oversized source does
// not waste passes on renders that will never fit; coverEdgeFloor is the
// smallest render we will settle for.
const (
	coverEdgeCeiling = 1000
	coverEdgeFloor   = 200
)

// downscaleCover re-encodes data as a JPEG small enough to embed (at most
// maxCoverBytes), progressively shrinking it until the encoded result fits.
// Returns the input unchanged if it already fits or cannot be decoded (embedding
// as-is beats dropping the cover).
func downscaleCover(data []byte) []byte {
	if len(data) <= maxCoverBytes {
		return data
	}

	src, _, err := image.Decode(bytes.NewReader(data))
	if err != nil {
		log.Printf("cover downscale: decode failed, embedding as-is: %v", err)
		return data
	}

	b := src.Bounds()
	longest := b.Dx()
	if b.Dy() > longest {
		longest = b.Dy()
	}
	if longest > coverEdgeCeiling {
		longest = coverEdgeCeiling
	}

	var smallest []byte
	for edge := longest; edge >= coverEdgeFloor; edge = edge * 4 / 5 {
		out, err := encodeCoverJPEG(src, edge)
		if err != nil {
			log.Printf("cover downscale: encode failed, embedding as-is: %v", err)
			return data
		}
		smallest = out
		if len(out) <= maxCoverBytes {
			return out
		}
	}
	// Even at the floor it didn't fit; embed the smallest render produced.
	return smallest
}

// encodeCoverJPEG scales src so its longest edge is edge px and returns it as a
// JPEG.
func encodeCoverJPEG(src image.Image, edge int) ([]byte, error) {
	b := src.Bounds()
	w, h := b.Dx(), b.Dy()
	nw, nh := edge, edge
	if w >= h {
		nh = h * edge / w
	} else {
		nw = w * edge / h
	}
	if nw < 1 {
		nw = 1
	}
	if nh < 1 {
		nh = 1
	}

	dst := image.NewRGBA(image.Rect(0, 0, nw, nh))
	xdraw.CatmullRom.Scale(dst, dst.Bounds(), src, b, xdraw.Over, nil)

	var buf bytes.Buffer
	if err := jpeg.Encode(&buf, dst, &jpeg.Options{Quality: 85}); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

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
	image = downscaleCover(image)

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
	image = downscaleCover(image)

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
