package models

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

type Track struct {
	gorm.Model
	Id       string
	Title    string
	Artist   string
	Duration int
	Cover    string
	Url      string
}
