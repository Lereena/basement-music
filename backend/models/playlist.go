package models

import "github.com/jinzhu/gorm"

type Playlist struct {
	gorm.Model
	Id     string
	Title  string
	Image  string
	Tracks []Track `gorm:"-"`
}

type PlaylistTrack struct {
	PlaylistID string `gorm:"primaryKey;column:playlist_id"`
	TrackID    string `gorm:"primaryKey;column:track_id"`
	Position   int
}
