package models

import "github.com/jinzhu/gorm"

type Artist struct {
	gorm.Model
	Id          string `gorm:"primaryKey"`
	Name        string
	Image       *string
	Description *string
	Tracks      []Track `gorm:"many2many:artist_tracks"`
	Albums      []Album `gorm:"many2many:album_artists"`
}
