package models

import "gorm.io/gorm"

// SoulseekCredentials stores the single Soulseek account the server uses to
// connect to the network. Admin overwrites the row on each save; only the most
// recent row matters.
type SoulseekCredentials struct {
	gorm.Model
	Username string
	Password string
}
