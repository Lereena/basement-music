package models

import "gorm.io/gorm"

type Album struct {
	gorm.Model
	Id      string `gorm:"primaryKey"`
	Title   string
	Year    *int
	Cover   *string  // "/api/album/{id}/image"
	Artists []Artist `gorm:"many2many:album_artists"`
	Tracks  []Track  `gorm:"foreignKey:AlbumId;references:Id"`
}
