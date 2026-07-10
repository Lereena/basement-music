package models

import (
	"time"

	"gorm.io/gorm"
)

// TrackID references Track.Id (string UUID), not the auto-increment primary key.
type ListenEvent struct {
	gorm.Model
	UserID        uint      `gorm:"not null;index"`
	TrackID       string    `gorm:"not null;index"`
	DurationMs    int64     `gorm:"not null"`
	StartedAt     time.Time `gorm:"not null;index"`
	ClientEventID string    `gorm:"not null;uniqueIndex"`
}
