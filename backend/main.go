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
	"github.com/Lereena/server_basement_music/middleware"
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

	authRepo := &repositories.AuthRepository{DB: db}
	authRepo.Init()

	adminRepo := &repositories.AdminRepository{DB: db}
	favsRepo := &repositories.FavouritesRepository{DB: db}

	localDirectoryWorker := &LocalDirectoryWorker{
		musicRepo:   musicRepo,
		artistsRepo: artistsRepo,
		Cfg:         &cfg,
	}
	localDirectoryWorker.ScanMusicDirectory()

	youtubeWorker := &YoutubeWorker{
		musicRepo: musicRepo,
		Cfg:       &cfg,
	}

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
	router.HandleFunc("/playlist/{id}/image", playlistsRepo.GetPlaylistImage).Methods("GET")

	// All other routes require a registered user
	protected := router.PathPrefix("").Subrouter()
	protected.Use(authMW)

	protected.HandleFunc("/auth/me", authRepo.Me).Methods("GET")

	// User routes
	protected.HandleFunc("/user/favourites", favsRepo.GetFavourites).Methods("GET")
	protected.HandleFunc("/user/favourites/{trackId}", favsRepo.AddFavourite).Methods("POST")
	protected.HandleFunc("/user/favourites/{trackId}", favsRepo.RemoveFavourite).Methods("DELETE")

	// Admin routes
	admin := protected.PathPrefix("/admin").Subrouter()
	admin.Use(middleware.AdminMiddleware)
	admin.HandleFunc("/registration-codes", adminRepo.GenerateCode).Methods("POST")
	admin.HandleFunc("/registration-codes", adminRepo.ListCodes).Methods("GET")

	protected.HandleFunc("/tracks", musicRepo.GetTracks).Methods("GET")
	protected.HandleFunc("/tracks/search", musicRepo.SearchTracks).Methods("GET")

	protected.HandleFunc("/track/{id}", musicRepo.GetTrack).Methods("GET")
	protected.HandleFunc("/track/{id}", musicRepo.EditTrack).Methods("PATCH")
	protected.HandleFunc("/track/upload", localDirectoryWorker.UploadFile).Methods("POST")

	protected.HandleFunc("/yt/fetchVideoInfo", youtubeWorker.FetchVideoInfo).Methods("GET")
	protected.HandleFunc("/yt/download", youtubeWorker.FetchFromYoutube).Methods("GET")

	protected.HandleFunc("/playlists", playlistsRepo.GetAllPlaylists).Methods("GET")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.GetPlaylist).Methods("GET")
	protected.HandleFunc("/playlist/create/{title}", playlistsRepo.CreatePlaylist).Methods("POST")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.EditPlaylist).Methods("PATCH")
	protected.HandleFunc("/playlist/{id}", playlistsRepo.DeletePlaylist).Methods("DELETE")
	protected.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.AddTrackToPlaylist).Methods("POST")
	protected.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.DeleteTrackFromPlaylist).Methods("DELETE")
	protected.HandleFunc("/playlist/{playlistId}/tracks/order", playlistsRepo.ReorderPlaylistTracks).Methods("PATCH")

	protected.HandleFunc("/artists", artistsRepo.GetAllArtists).Methods("GET")
	protected.HandleFunc("/artist/{id}", artistsRepo.GetArtist).Methods("GET")
	admin.HandleFunc("/artist/{id}/image", artistsRepo.UpdateArtistImage).Methods("PATCH")
	admin.HandleFunc("/playlist/{id}/image", playlistsRepo.UpdatePlaylistImage).Methods("PATCH")

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Authorization", "Content-Type"},
		AllowCredentials: false,
	})
	handler := c.Handler(router)

	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%s", cfg.ListenHost, cfg.ListenPort), handler))
}
