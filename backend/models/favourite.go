package models

import "gorm.io/gorm"

// TrackID references Track.Id (string UUID), not the auto-increment primary key.
type Favourite struct {
	gorm.Model
	UserID  uint   `gorm:"not null;index"`
	TrackID string `gorm:"not null;index"`
}
