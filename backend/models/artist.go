package models

import "github.com/jinzhu/gorm"

type Artist struct {
	gorm.Model
	Id     string
	Name   string
	Image  string
	Tracks []Track `gorm:"many2many:artist_tracks"`
}
