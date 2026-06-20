package models

import "gorm.io/gorm"

type RegistrationCode struct {
	gorm.Model
	Code     string `gorm:"uniqueIndex;not null"`
	UsedByID *uint
	UsedBy   *User `gorm:"foreignKey:UsedByID"`
}
