package config

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Config struct {
	PGHost     string
	PGPort     string
	PGUser     string
	PGPassword string
	PGDB       string
	FilePath   string
	ListenPort string
	ListenHost string
	MusicPath  string
}

func LoadFromEnv() Config {
	return Config{
		PGHost:     os.Getenv("POSTGRES_HOST"),
		PGPort:     os.Getenv("POSTGRES_PORT"),
		PGUser:     os.Getenv("POSTGRES_USER"),
		PGPassword: os.Getenv("POSTGRES_PASSWORD"),
		PGDB:       os.Getenv("POSTGRES_DB"),
		ListenPort: os.Getenv("LISTEN_PORT"),
		ListenHost: os.Getenv("LISTEN_HOST"),
		MusicPath:  filepath.FromSlash(os.Getenv("MUSIC_PATH")),
	}
}

func (cfg *Config) InitDB() *gorm.DB {
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s sslmode=disable dbname=%s",
		cfg.PGHost,
		cfg.PGPort,
		cfg.PGUser,
		cfg.PGPassword,
		cfg.PGDB,
	)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{QueryFields: true})

	if err != nil {
		panic(fmt.Errorf("failed to connect to db via gorm: %s", err.Error()))
	}

	return db
}

func (cfg *Config) GetTrackDuration(name string) int {
	path := filepath.Join(cfg.MusicPath, name)
	cmd := exec.Command("ffprobe", "-i", path, "-show_entries", "format=duration")

	fmt.Println(cmd)
	var stderr bytes.Buffer
	var stdout bytes.Buffer
	cmd.Stderr = &stderr
	cmd.Stdout = &stdout

	err := cmd.Run()
	if err != nil {
		fmt.Println("Couldn't fetch", path, "duration: ", err.Error(), stderr.String())
	}

	durationString := strings.Split(strings.Split(stdout.String(), "\n")[1], "=")[1]
	duration, err := strconv.ParseFloat(durationString, 64)
	if err != nil {
		fmt.Println(path, "duration has incorrect format:", durationString)
	}

	return int(duration)
}
