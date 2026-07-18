package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"github.com/bogem/id3v2/v2"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/repositories"
	"gorm.io/gorm"
)

type LocalDirectoryWorker struct {
	musicRepo   *repositories.TracksRepository
	artistsRepo *repositories.ArtistsRepository
	albumsRepo  *repositories.AlbumsRepository
	Cfg         *config.Config
}

func (ldw *LocalDirectoryWorker) ScanMusicDirectory() {
	files, err := ioutil.ReadDir(ldw.Cfg.MusicPath)
	log.Printf("File Path = %s", ldw.Cfg.MusicPath)

	if err != nil {
		log.Printf("Couldn't read music directory content: %v", err)
		return
	}

	// Remove pre-existing duplicate track rows (same song, dash-variant filenames)
	// before rebuilding associations, so stale rows don't resurface on the artist
	// page. On-disk filenames are passed so a survivor whose file still exists is
	// preferred over a newer row whose file is gone. A failed dedup aborts the
	// scan: with duplicates still present, the canonical lookup below could bind
	// associations to a stale row, which is worse than a skipped scan.
	diskFiles := make([]string, 0, len(files))
	for _, f := range files {
		if !f.IsDir() {
			diskFiles = append(diskFiles, f.Name())
		}
	}
	if err := ldw.dedupTracks(diskFiles); err != nil {
		log.Printf("Error deduping tracks, aborting scan: %v", err)
		return
	}

	// Tracks are identified by dash-canonical url, so two files for the same song
	// that differ only by dash character resolve to a single track. Matching is
	// done in Go against tracks loaded once up front — a per-file regexp match in
	// SQL cannot use an index, so it would rescan the whole table for every file.
	// Loaded before artist_tracks is cleared so a load failure leaves the current
	// artist bindings intact.
	var allTracks []models.Track
	if err := ldw.musicRepo.DB.Find(&allTracks).Error; err != nil {
		log.Printf("Error loading tracks, aborting scan: %v", err)
		return
	}
	tracksByCanonUrl := make(map[string]models.Track, len(allTracks))
	for _, t := range allTracks {
		tracksByCanonUrl[canonicalizeDashes(t.Url)] = t
	}

	// Rebuild of artist_tracks is idempotent (CreateArtist is find-or-create).
	// Artists themselves are durable now — never wiped — so curated data
	// (descriptions/images/album links) survives restarts and rescans.
	err = ldw.artistsRepo.DB.Exec("DELETE FROM artist_tracks").Error
	if err != nil {
		log.Printf("Error clearing artist_tracks table: %v", err)
	}

	// seen guards against processing the second dash-variant file twice within
	// one scan.
	seen := map[string]bool{}
	for _, f := range files {
		if f.IsDir() {
			continue
		}
		canonUrl := canonicalizeDashes(f.Name())
		if seen[canonUrl] {
			log.Printf("Skipping duplicate song file: %s", f.Name())
			continue
		}
		seen[canonUrl] = true

		track, ok := tracksByCanonUrl[canonUrl]
		if !ok {
			ldw.saveTrack(f.Name())
			if err := ldw.musicRepo.DB.Where("url = ?", f.Name()).First(&track).Error; err != nil {
				log.Printf("Track for file '%s' missing after save, skipping: %v", f.Name(), err)
				continue
			}
			tracksByCanonUrl[canonUrl] = track
		}

		ldw.handleArtists(track.Artist, track.Id)
		ldw.handleAlbum(track)
		ldw.handleCover(track.Id)
	}

	ldw.pruneOrphanArtists()
}

// dedupTracks hard-deletes duplicate track rows that represent the same song via
// dash-variant filenames (e.g. "Artist - Song" vs "Artist — Song"). Per canonical
// url the survivor is the row whose url matches a file currently on disk
// (diskFiles), falling back to the most recently created row — so a stale row
// pointing at a deleted file never outlives the row whose file is still playable.
// Before deleting, references from playlists, favourites and listen events are
// repointed from each doomed loser to its survivor so no user data is silently
// dropped. Album/cover bindings are re-derived by the scan that follows, so those
// need no repointing here; artist_tracks rows for losers are removed inside the
// transaction only so a foreign key on the join table cannot fail the tracks
// delete.
//
// Duplicate groups are computed in Go and the SQL avoids window functions, temp
// tables and regexp, so the routine also runs on the sqlite driver used in tests.
// All groups run in one transaction: either every duplicate is resolved or, on
// error, none is — the caller aborts the scan in that case.
func (ldw *LocalDirectoryWorker) dedupTracks(diskFiles []string) error {
	var tracks []models.Track
	if err := ldw.musicRepo.DB.Find(&tracks).Error; err != nil {
		return err
	}

	onDisk := make(map[string]bool, len(diskFiles))
	for _, f := range diskFiles {
		onDisk[f] = true
	}
	groups := map[string][]models.Track{}
	for _, t := range tracks {
		canon := canonicalizeDashes(t.Url)
		groups[canon] = append(groups[canon], t)
	}

	return ldw.musicRepo.DB.Transaction(func(tx *gorm.DB) error {
		for _, group := range groups {
			if len(group) < 2 {
				continue
			}
			// Survivor preference: url present on disk, then newest CreatedAt; the
			// Id tie-break keeps the pick deterministic when CreatedAt collides.
			sort.Slice(group, func(i, j int) bool {
				if onDisk[group[i].Url] != onDisk[group[j].Url] {
					return onDisk[group[i].Url]
				}
				if !group[i].CreatedAt.Equal(group[j].CreatedAt) {
					return group[i].CreatedAt.After(group[j].CreatedAt)
				}
				return group[i].Id > group[j].Id
			})

			survivor := group[0]
			loserIds := make([]string, 0, len(group)-1)
			for _, loser := range group[1:] {
				log.Printf("Deduping track: keeping '%s', removing DB row for '%s'", survivor.Url, loser.Url)
				loserIds = append(loserIds, loser.Id)
			}

			if err := dedupGroup(tx, survivor.Id, loserIds); err != nil {
				return err
			}
		}
		return nil
	})
}

// dedupGroup repoints references from loserIds to survivorId, then deletes the
// loser track rows. Delete-before-repoint ordering matters for playlist_tracks
// (composite PK would collide) and favourites (no unique constraint, so a
// colliding repoint would not error — it would silently leave duplicate rows):
// first drop loser rows that would collide with an existing survivor row or with
// each other, then repoint the at-most-one row left per group.
func dedupGroup(tx *gorm.DB, survivorId string, loserIds []string) error {
	// artist_tracks is fully rebuilt by the scan after dedup; losers are removed
	// here only so a foreign key on the join table cannot fail the tracks delete.
	if err := tx.Exec(`DELETE FROM artist_tracks WHERE track_id IN ?`, loserIds).Error; err != nil {
		return err
	}

	// Playlists: drop loser rows in playlists that already hold the survivor,
	if err := tx.Exec(`
		DELETE FROM playlist_tracks
		WHERE track_id IN ?
		  AND playlist_id IN (SELECT pt2.playlist_id FROM playlist_tracks pt2 WHERE pt2.track_id = ?)
	`, loserIds, survivorId).Error; err != nil {
		return err
	}
	// then keep only the earliest-positioned loser per remaining playlist. The
	// kept row is the group minimum, which no progressive evaluation can delete,
	// so the statement is safe even where self-referencing DELETE semantics are
	// weakest (sqlite).
	if err := tx.Exec(`
		DELETE FROM playlist_tracks
		WHERE track_id IN ?
		  AND EXISTS (
			SELECT 1 FROM playlist_tracks pt2
			WHERE pt2.playlist_id = playlist_tracks.playlist_id
			  AND pt2.track_id IN ?
			  AND (pt2.position < playlist_tracks.position
			       OR (pt2.position = playlist_tracks.position AND pt2.track_id < playlist_tracks.track_id))
		  )
	`, loserIds, loserIds).Error; err != nil {
		return err
	}
	if err := tx.Exec(`UPDATE playlist_tracks SET track_id = ? WHERE track_id IN ?`, survivorId, loserIds).Error; err != nil {
		return err
	}

	// Favourites: drop active loser rows for users who already actively favourite
	// the survivor,
	if err := tx.Exec(`
		DELETE FROM favourites
		WHERE track_id IN ?
		  AND deleted_at IS NULL
		  AND user_id IN (SELECT f2.user_id FROM favourites f2 WHERE f2.track_id = ? AND f2.deleted_at IS NULL)
	`, loserIds, survivorId).Error; err != nil {
		return err
	}
	// then keep only the oldest active loser row per user.
	if err := tx.Exec(`
		DELETE FROM favourites
		WHERE track_id IN ?
		  AND deleted_at IS NULL
		  AND EXISTS (
			SELECT 1 FROM favourites f2
			WHERE f2.user_id = favourites.user_id
			  AND f2.track_id IN ?
			  AND f2.deleted_at IS NULL
			  AND (f2.created_at < favourites.created_at
			       OR (f2.created_at = favourites.created_at AND f2.id < favourites.id))
		  )
	`, loserIds, loserIds).Error; err != nil {
		return err
	}
	// Repoint everything left, including soft-deleted rows, so unfavourite
	// history moves to the survivor instead of being dropped.
	if err := tx.Exec(`UPDATE favourites SET track_id = ? WHERE track_id IN ?`, survivorId, loserIds).Error; err != nil {
		return err
	}

	// Listen events: repoint every row (track_id has no uniqueness) so play
	// history is preserved under the survivor.
	if err := tx.Exec(`UPDATE listen_events SET track_id = ? WHERE track_id IN ?`, survivorId, loserIds).Error; err != nil {
		return err
	}

	// Finally hard-delete the duplicate track rows themselves.
	return tx.Exec(`DELETE FROM tracks WHERE id IN ?`, loserIds).Error
}

// pruneOrphanArtists removes artists left with no tracks, no albums, and no
// curated metadata — i.e. artists that only existed because of tracks now gone.
// Curated artists (with a description or image) are always kept.
func (ldw *LocalDirectoryWorker) pruneOrphanArtists() {
	err := ldw.artistsRepo.DB.Exec(`
		DELETE FROM artists a
		WHERE NOT EXISTS (SELECT 1 FROM artist_tracks at WHERE at.artist_id = a.id)
		  AND NOT EXISTS (SELECT 1 FROM album_artists aa WHERE aa.artist_id = a.id)
		  AND a.description IS NULL AND a.image IS NULL
	`).Error
	if err != nil {
		log.Printf("Error pruning orphan artists: %v", err)
	}
}

// handleAlbum derives an album from the track's embedded TALB (album) frame.
// Only .mp3 files carry ID3 tags. Never overwrites a non-nil AlbumId so manual
// bindings always win over scan-derived ones.
func (ldw *LocalDirectoryWorker) handleAlbum(track models.Track) {
	if track.AlbumId != nil {
		return
	}
	if !strings.EqualFold(filepath.Ext(track.Url), ".mp3") {
		return
	}

	path := filepath.Join(ldw.Cfg.MusicPath, track.Url)
	tag, err := id3v2.Open(path, id3v2.Options{Parse: true, ParseFrames: []string{"TALB"}})
	if err != nil {
		return
	}
	title := strings.TrimSpace(tag.Album())
	tag.Close()
	if title == "" {
		return
	}

	var artistIds []string
	ldw.artistsRepo.DB.
		Table("artist_tracks").
		Where("track_id = ?", track.Id).
		Pluck("artist_id", &artistIds)

	albumId := ldw.albumsRepo.FindOrCreateAlbum(title, artistIds)
	ldw.musicRepo.DB.Model(&models.Track{}).Where("id = ?", track.Id).Update("album_id", albumId)
}

// handleCover backfills the track's cover: from the album image when the track
// is bound to an album that has one, otherwise from a picture already embedded
// in the file's metadata.
func (ldw *LocalDirectoryWorker) handleCover(trackId string) {
	if trackId == "" {
		return
	}
	ldw.albumsRepo.SyncAlbumCoverToTrack(trackId)
	ldw.musicRepo.BackfillCoverFromFile(trackId)
}

func (ldw *LocalDirectoryWorker) UploadFile(w http.ResponseWriter, r *http.Request) {
	err := r.ParseMultipartForm(32 << 20)
	if err != nil {
		http.Error(w, "Error parsing form: "+err.Error(), http.StatusBadRequest)
		return
	}

	files := r.MultipartForm.File["files"]

	for _, file := range files {
		src, err := file.Open()
		if err != nil {
			http.Error(w, "Error opening file: "+err.Error(), http.StatusInternalServerError)
			return
		}
		defer src.Close()

		name := "music/" + file.Filename
		fmt.Printf("File name %s\n", name)

		out, err := os.Create(name)
		if err != nil {
			http.Error(w, "Error creating destination file: "+err.Error(), http.StatusInternalServerError)
			return
		}
		defer out.Close()

		_, err = io.Copy(out, src)
		if err != nil {
			http.Error(w, "Error copying file: "+err.Error(), http.StatusInternalServerError)
			return
		}

		ldw.saveTrack(file.Filename)

		track := models.Track{}
		ldw.musicRepo.DB.Where("Url = ?", file.Filename).First(&track)
		ldw.handleArtists(track.Artist, track.Id)
		ldw.handleAlbum(track)
		ldw.handleCover(track.Id)
	}
}

func (ldw *LocalDirectoryWorker) saveTrack(filename string) {
	splitSymbolsRegexp := regexp.MustCompile(splitSymbols)

	titleSplit := splitSymbolsRegexp.Split(filename, -1)

	if len(titleSplit) == 1 {
		log.Printf("Title '%s' has no split symbols, skipping", filename)
		return
	}

	fmt.Println(filename)
	artists, title := strings.TrimSpace(titleSplit[0]), strings.TrimSpace(titleSplit[1])

	index := strings.LastIndex(title, ".")
	if index > -1 {
		title = title[:index]
	}

	duration := ldw.Cfg.GetTrackDuration(filename)
	ldw.musicRepo.CreateTrack(artists, title, duration, filename, "")
}

func (ldw *LocalDirectoryWorker) handleArtists(artists string, trackId string) {
	// Extract artist names from the track's artist field
	artistNames := strings.Split(artists, ",")

	// Create artist-track entries in the database
	for _, artistName := range artistNames {
		name := strings.TrimSpace(artistName)
		if name == "" {
			continue
		}
		artistId := ldw.artistsRepo.CreateArtist(name)

		err := ldw.artistsRepo.AssociateTrackWithArtist(artistId, trackId)

		if err != nil {
			log.Printf("Error associating artist with track: %v", err)
		}
	}
}
