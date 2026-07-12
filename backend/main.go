package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"github.com/rs/cors"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/lrclib"
	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/musicbrainz"
	"github.com/Lereena/server_basement_music/repositories"
)

func main() {
	cfg := config.LoadFromEnv()
	log.Printf("Config: %+v", cfg)

	db := cfg.InitDB()
	firebaseApp := config.InitFirebase()

	authClient, err := firebaseApp.Auth(context.Background())
	if err != nil {
		log.Fatalf("firebase auth client: %v", err)
	}
	// Pre-warm JWKS cache so first real request doesn't block on key fetch.
	go authClient.VerifyIDToken(context.Background(), "warmup") //nolint:errcheck

	musicRepo := &repositories.TracksRepository{
		DB:  db,
		Cfg: &cfg,
	}
	musicRepo.Init()

	playlistsRepo := &repositories.PlaylistsRepository{DB: db, Cfg: &cfg}
	playlistsRepo.Init()

	artistsRepo := &repositories.ArtistsRepository{DB: db, Cfg: &cfg}
	artistsRepo.Init()

	albumsRepo := &repositories.AlbumsRepository{DB: db, Cfg: &cfg}
	albumsRepo.Init()

	authRepo := &repositories.AuthRepository{DB: db}
	authRepo.Init()

	adminRepo := &repositories.AdminRepository{DB: db}
	favsRepo := &repositories.FavouritesRepository{DB: db}
	lyricsRepo := &repositories.LyricsRepository{DB: db, Cfg: &cfg, Lrclib: lrclib.NewClient()}
	metadataRepo := &repositories.MetadataRepository{DB: db, Cfg: &cfg, MB: musicbrainz.NewClient(), Albums: albumsRepo}

	statsRepo := &repositories.StatsRepository{DB: db}
	statsRepo.Init()

	localDirectoryWorker := &LocalDirectoryWorker{
		musicRepo:   musicRepo,
		artistsRepo: artistsRepo,
		albumsRepo:  albumsRepo,
		Cfg:         &cfg,
	}
	localDirectoryWorker.ScanMusicDirectory()

	youtubeWorker := &YoutubeWorker{
		musicRepo: musicRepo,
		Cfg:       &cfg,
	}

	soulseekWorker := NewSoulseekWorker(&cfg)
	slskRepo := &SoulseekRepository{
		DB:          db,
		Cfg:         &cfg,
		Worker:      soulseekWorker,
		musicRepo:   musicRepo,
		artistsRepo: artistsRepo,
	}
	db.AutoMigrate(&models.SoulseekCredentials{}, &models.SoulseekSettings{})
	// Auto-reconnect using stored credentials, if any.
	go slskRepo.Connect()

	authMW := middleware.AuthMiddleware(authClient, db)
	tokenOnlyMW := middleware.TokenOnlyMiddleware(authClient)

	router := mux.NewRouter().PathPrefix("/api").Subrouter()

	// Public auth route — token verified but user need not exist in DB yet
	router.Handle(
		"/auth/register",
		tokenOnlyMW(http.HandlerFunc(authRepo.Register)),
	).Methods("POST")

	// Audio stream is public — audioplayers can't attach headers, IDs are non-enumerable UUIDs
	router.HandleFunc("/track/{id}", musicRepo.GetTrack).Methods("GET")

	// Images are public — Image.network can't attach auth headers
	router.HandleFunc("/artist/{id}/image", artistsRepo.GetArtistImage).Methods("GET")
	router.HandleFunc("/album/{id}/image", albumsRepo.GetAlbumImage).Methods("GET")
	router.HandleFunc("/track/{id}/cover", musicRepo.GetTrackCover).Methods("GET")
	router.HandleFunc("/playlist/{id}/image", playlistsRepo.GetPlaylistImage).Methods("GET")

	// Temp Soulseek audio is public — audioplayers can't attach headers, IDs are non-enumerable UUIDs
	router.HandleFunc("/soulseek/temp/{id}", slskRepo.ServeTemp).Methods("GET")

	// All other routes require a registered user
	protected := router.PathPrefix("").Subrouter()
	protected.Use(authMW)

	protected.HandleFunc("/auth/me", authRepo.Me).Methods("GET")

	// User routes
	protected.HandleFunc("/user/favourites", favsRepo.GetFavourites).Methods("GET")
	protected.HandleFunc("/user/favourites/{trackId}", favsRepo.AddFavourite).Methods("POST")
	protected.HandleFunc("/user/favourites/{trackId}", favsRepo.RemoveFavourite).Methods("DELETE")
	protected.HandleFunc("/user/listens", statsRepo.PostListens).Methods("POST")

	// Admin routes
	admin := protected.PathPrefix("/admin").Subrouter()
	admin.Use(middleware.AdminMiddleware)
	admin.HandleFunc("/listens", statsRepo.GetListens).Methods("GET")
	admin.HandleFunc("/registration-codes", adminRepo.GenerateCode).Methods("POST")
	admin.HandleFunc("/registration-codes", adminRepo.ListCodes).Methods("GET")
	admin.HandleFunc("/soulseek/credentials", slskRepo.SetCredentials).Methods("POST")
	admin.HandleFunc("/soulseek/status", slskRepo.GetStatus).Methods("GET")
	admin.HandleFunc("/soulseek/disconnect", slskRepo.Disconnect).Methods("POST")
	admin.HandleFunc("/soulseek/settings", slskRepo.GetSettings).Methods("GET")
	admin.HandleFunc("/soulseek/settings", slskRepo.SetSettings).Methods("POST")

	protected.HandleFunc("/tracks", musicRepo.GetTracks).Methods("GET")
	protected.HandleFunc("/tracks/search", musicRepo.SearchTracks).Methods("GET")

	protected.HandleFunc("/track/{id}", musicRepo.GetTrack).Methods("GET")
	protected.HandleFunc("/track/{id}", musicRepo.EditTrack).Methods("PATCH")
	protected.HandleFunc("/track/upload", localDirectoryWorker.UploadFile).Methods("POST")

	protected.HandleFunc("/track/{id}/lyrics/file", lyricsRepo.GetFileLyrics).Methods("GET")
	protected.HandleFunc("/track/{id}/lyrics/search", lyricsRepo.SearchLyrics).Methods("GET")
	protected.HandleFunc("/track/{id}/lyrics", lyricsRepo.SaveLyrics).Methods("POST")

	protected.HandleFunc("/yt/fetchVideoInfo", youtubeWorker.FetchVideoInfo).Methods("GET")
	protected.HandleFunc("/yt/download", youtubeWorker.FetchFromYoutube).Methods("GET")

	protected.HandleFunc("/soulseek/connection", slskRepo.GetConnection).Methods("GET")
	protected.HandleFunc("/soulseek/search", slskRepo.Search).Methods("GET")
	protected.HandleFunc("/soulseek/search/results", slskRepo.SearchResults).Methods("GET")
	protected.HandleFunc("/soulseek/preload", slskRepo.Preload).Methods("POST")
	protected.HandleFunc("/soulseek/save", slskRepo.SaveTrack).Methods("POST")
	protected.HandleFunc("/soulseek/temp", slskRepo.CleanupSession).Methods("DELETE")

	protected.HandleFunc("/playlists", playlistsRepo.GetAllPlaylists).Methods("GET")
	protected.HandleFunc("/playlists/search", playlistsRepo.SearchPlaylists).Methods("GET")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.GetPlaylist).Methods("GET")
	protected.HandleFunc("/playlist/create/{title}", playlistsRepo.CreatePlaylist).Methods("POST")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.EditPlaylist).Methods("PATCH")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.DeletePlaylist).Methods("DELETE")
	protected.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.AddTrackToPlaylist).Methods("POST")
	protected.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.DeleteTrackFromPlaylist).Methods("DELETE")
	protected.HandleFunc("/playlist/{playlistId}/tracks/order", playlistsRepo.ReorderPlaylistTracks).Methods("PATCH")

	protected.HandleFunc("/artists", artistsRepo.GetAllArtists).Methods("GET")
	protected.HandleFunc("/artists/search", artistsRepo.SearchArtists).Methods("GET")
	protected.HandleFunc("/artist/{id}", artistsRepo.GetArtist).Methods("GET")
	protected.HandleFunc("/artist/{id}", artistsRepo.EditArtist).Methods("PATCH")
	protected.HandleFunc("/track/{trackId}/artists", artistsRepo.SetTrackArtists).Methods("PATCH")
	protected.HandleFunc("/artist/{id}/image", artistsRepo.UpdateArtistImage).Methods("PATCH")
	protected.HandleFunc("/playlist/{id}/image", playlistsRepo.UpdatePlaylistImage).Methods("PATCH")

	// Albums
	protected.HandleFunc("/albums", albumsRepo.GetAllAlbums).Methods("GET")
	protected.HandleFunc("/album/{id}", albumsRepo.GetAlbum).Methods("GET")
	protected.HandleFunc("/album", albumsRepo.CreateAlbum).Methods("POST")
	protected.HandleFunc("/album/{id}", albumsRepo.EditAlbum).Methods("PATCH")
	protected.HandleFunc("/album/{id}", albumsRepo.DeleteAlbum).Methods("DELETE")
	protected.HandleFunc("/album/{id}/artists", albumsRepo.SetAlbumArtists).Methods("PATCH")
	protected.HandleFunc("/album/{id}/tracks", albumsRepo.SetAlbumTracks).Methods("PATCH")
	protected.HandleFunc("/album/{id}/image", albumsRepo.UpdateAlbumImage).Methods("PATCH")
	protected.HandleFunc("/track/{trackId}/album", albumsRepo.SetTrackAlbum).Methods("PATCH")

	// Metadata (MusicBrainz / CoverArtArchive)
	protected.HandleFunc("/artist/{id}/metadata/search", metadataRepo.SearchArtistMetadata).Methods("GET")
	protected.HandleFunc("/artist/{id}/metadata/preview", metadataRepo.PreviewArtistMetadata).Methods("GET")
	protected.HandleFunc("/artist/{id}/metadata/apply", metadataRepo.ApplyArtistMetadata).Methods("POST")
	protected.HandleFunc("/album/{id}/cover/search", metadataRepo.SearchAlbumCover).Methods("GET")
	protected.HandleFunc("/album/{id}/cover/apply", metadataRepo.ApplyAlbumCover).Methods("POST")

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Authorization", "Content-Type"},
		AllowCredentials: false,
	})
	handler := c.Handler(router)

	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%s", cfg.ListenHost, cfg.ListenPort), handler))
}
