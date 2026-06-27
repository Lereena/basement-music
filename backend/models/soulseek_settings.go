package models

import "gorm.io/gorm"

// SoulseekSettings holds server-wide Soulseek configuration. Exactly one row.
type SoulseekSettings struct {
	gorm.Model
	DisconnectAfterMinutes int
}
