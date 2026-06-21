package models

import "github.com/jinzhu/gorm"

type Playlist struct {
	gorm.Model
	Id     string
	Title  string
	Image  string
	Tracks []Track `gorm:"many2many:playlist_tracks"`
}
