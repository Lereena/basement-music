package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	FirebaseUID string `gorm:"uniqueIndex;not null" json:"firebase_uid"`
	Email       string `gorm:"uniqueIndex;not null" json:"email"`
	Role        string `gorm:"not null;default:'user'" json:"role"`
}
