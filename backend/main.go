package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"github.com/rs/cors"

	"github.com/Lereena/server_basement_music/config"
	"github.com/Lereena/server_basement_music/repositories"
)

func main() {
	cfg := config.LoadFromEnv()
	log.Printf("Config: %+v", cfg)

	db := cfg.InitDB()

	musicRepo := &repositories.TracksRepository{
		DB:  db,
		Cfg: &cfg,
	}
	musicRepo.Init()

	playlistsRepo := &repositories.PlaylistsRepository{DB: db}
	playlistsRepo.Init()

	artistsRepo := &repositories.ArtistsRepository{DB: db}
	artistsRepo.Init()

	localDirectoryWorker := &LocalDirectoryWorker{
		musicRepo: musicRepo,
		Cfg:       &cfg,
	}
	localDirectoryWorker.ScanMusicDirectory()

	youtubeWorker := &YoutubeWorker{
		musicRepo: musicRepo,
		Cfg:       &cfg,
	}

	router := mux.NewRouter().PathPrefix("/api").Subrouter()
	router.HandleFunc("/tracks", musicRepo.GetTracks).Methods("GET")
	router.HandleFunc("/tracks/search", musicRepo.SearchTracks).Methods("GET")

	router.HandleFunc("/track/{id}", musicRepo.GetTrack).Methods("GET")
	router.HandleFunc("/track/{id}", musicRepo.EditTrack).Methods("PATCH")
	router.HandleFunc("/track/upload", localDirectoryWorker.UploadFile).Methods("POST")

	router.HandleFunc("/yt/fetchVideoInfo", youtubeWorker.FetchVideoInfo).Methods("GET")
	router.HandleFunc("/yt/download", youtubeWorker.FetchFromYoutube).Methods("GET")

	router.HandleFunc("/playlists", playlistsRepo.GetAllPlaylists).Methods("GET")
	router.HandleFunc("/playlist/{id}", playlistsRepo.GetPlaylist).Methods("GET")
	router.HandleFunc("/playlist/create/{title}", playlistsRepo.CreatePlaylist).Methods("POST")
	router.HandleFunc("/playlist/{id}", playlistsRepo.EditPlaylist).Methods("PATCH")
	router.HandleFunc("/playlist/{id}", playlistsRepo.DeletePlaylist).Methods("DELETE")
	router.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.AddTrackToPlaylist).Methods("POST")
	router.HandleFunc("/playlist/{playlistId}/track/{trackId}", playlistsRepo.DeleteTrackFromPlaylist).Methods("DELETE")

	router.HandleFunc("/artists", artistsRepo.GetAllArtists).Methods("GET")
	router.HandleFunc("/artist/{id}", artistsRepo.GetArtist).Methods("GET")

	handler := cors.Default().Handler(router)

	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%s", cfg.ListenHost, cfg.ListenPort), handler))
}
