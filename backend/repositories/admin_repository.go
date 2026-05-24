package repositories

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type AdminRepository struct {
	DB *gorm.DB
}

type registrationCodeResponse struct {
	ID          uint      `json:"id"`
	Code        string    `json:"code"`
	UsedByEmail *string   `json:"used_by_email"`
	CreatedAt   time.Time `json:"created_at"`
}

// POST /api/admin/registration-codes
func (repo *AdminRepository) GenerateCode(w http.ResponseWriter, r *http.Request) {
	code := models.RegistrationCode{Code: uuid.New().String()}
	if err := repo.DB.Create(&code).Error; err != nil {
		respond.RespondError(w, http.StatusInternalServerError, err.Error())
		return
	}
	resp := registrationCodeResponse{
		ID:        code.ID,
		Code:      code.Code,
		CreatedAt: code.CreatedAt,
	}
	respond.RespondJSON(w, http.StatusCreated, resp)
}

// GET /api/admin/registration-codes
func (repo *AdminRepository) ListCodes(w http.ResponseWriter, r *http.Request) {
	var codes []models.RegistrationCode
	repo.DB.Preload("UsedBy").Order("created_at DESC").Find(&codes)

	result := make([]registrationCodeResponse, len(codes))
	for i, c := range codes {
		resp := registrationCodeResponse{
			ID:        c.ID,
			Code:      c.Code,
			CreatedAt: c.CreatedAt,
		}
		if c.UsedBy != nil {
			resp.UsedByEmail = &c.UsedBy.Email
		}
		result[i] = resp
	}

	json.NewEncoder(w).Encode(result)
}
