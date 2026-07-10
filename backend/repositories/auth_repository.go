package repositories

import (
	"encoding/json"
	"net/http"

	"github.com/Lereena/server_basement_music/middleware"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"gorm.io/gorm"
)

type userResponse struct {
	ID          uint   `json:"id"`
	FirebaseUID string `json:"firebase_uid"`
	Email       string `json:"email"`
	Role        string `json:"role"`
}

func toUserResponse(u models.User) userResponse {
	return userResponse{
		ID:          u.ID,
		FirebaseUID: u.FirebaseUID,
		Email:       u.Email,
		Role:        u.Role,
	}
}

type AuthRepository struct {
	DB *gorm.DB
}

func (repo *AuthRepository) Init() {
	repo.DB.AutoMigrate(&models.User{}, &models.RegistrationCode{})
}

// POST /api/auth/register
// Requires TokenOnlyMiddleware (firebase_uid + email in context, no DB user yet).
// Body: { "code": "..." }
func (repo *AuthRepository) Register(w http.ResponseWriter, r *http.Request) {
	firebaseUID, email := middleware.FirebaseUIDFromContext(r.Context())
	if firebaseUID == "" {
		respond.RespondError(w, http.StatusUnauthorized, "missing firebase uid")
		return
	}

	var body struct {
		Code string `json:"code"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil || body.Code == "" {
		respond.RespondError(w, http.StatusBadRequest, "code required")
		return
	}

	var user models.User
	err := repo.DB.Transaction(func(tx *gorm.DB) error {
		var code models.RegistrationCode
		if err := tx.Where("code = ? AND used_by_id IS NULL", body.Code).First(&code).Error; err != nil {
			return &registrationError{msg: "invalid or already-used code", status: http.StatusBadRequest}
		}

		var count int64
		tx.Model(&models.User{}).Count(&count)
		role := "user"
		if count == 0 {
			role = "admin"
		}

		user = models.User{
			FirebaseUID: firebaseUID,
			Email:       email,
			Role:        role,
		}
		if err := tx.Create(&user).Error; err != nil {
			return &registrationError{msg: "user already exists", status: http.StatusConflict}
		}

		return tx.Model(&code).Update("used_by_id", user.ID).Error
	})

	if err != nil {
		if re, ok := err.(*registrationError); ok {
			respond.RespondError(w, re.status, re.msg)
		} else {
			respond.RespondError(w, http.StatusInternalServerError, err.Error())
		}
		return
	}

	respond.RespondJSON(w, http.StatusCreated, toUserResponse(user))
}

// GET /api/auth/me
// Requires AuthMiddleware.
func (repo *AuthRepository) Me(w http.ResponseWriter, r *http.Request) {
	user, _ := middleware.UserFromContext(r.Context())
	respond.RespondJSON(w, http.StatusOK, toUserResponse(*user))
}

type registrationError struct {
	msg    string
	status int
}

func (e *registrationError) Error() string { return e.msg }
