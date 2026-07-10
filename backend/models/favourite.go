package models

import "gorm.io/gorm"

// Favourite item types.
const (
	FavouriteTrack    = "track"
	FavouritePlaylist = "playlist"
	FavouriteArtist   = "artist"
	FavouriteAlbum    = "album"
)

// ItemID references the string UUID of the favourited entity
// (Track.Id / Playlist.Id / Artist.Id / Album.Id), not the auto-increment primary key.
type Favourite struct {
	gorm.Model
	UserID   uint   `gorm:"not null;index"`
	ItemType string `gorm:"not null;index;default:'track'"`
	ItemID   string `gorm:"not null;index;default:''"`
}
