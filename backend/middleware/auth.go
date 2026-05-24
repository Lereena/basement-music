package middleware

import (
	"context"
	"net/http"
	"strings"

	firebase "firebase.google.com/go/v4"
	"github.com/Lereena/server_basement_music/models"
	"github.com/Lereena/server_basement_music/respond"
	"gorm.io/gorm"
)

type contextKey string

const (
	UserContextKey        contextKey = "user"
	firebaseUIDContextKey contextKey = "firebase_uid"
	emailContextKey       contextKey = "email"
)

// TokenOnlyMiddleware verifies the Firebase ID token and puts firebase_uid + email
// in context, but does NOT require the user to exist in the DB.
// Use for /auth/register only.
func TokenOnlyMiddleware(firebaseApp *firebase.App) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			idToken, ok := extractBearerToken(r)
			if !ok {
				respond.RespondError(w, http.StatusUnauthorized, "missing token")
				return
			}

			client, err := firebaseApp.Auth(r.Context())
			if err != nil {
				respond.RespondError(w, http.StatusInternalServerError, "firebase auth unavailable")
				return
			}

			token, err := client.VerifyIDToken(r.Context(), idToken)
			if err != nil {
				respond.RespondError(w, http.StatusUnauthorized, "invalid token")
				return
			}

			email, _ := token.Claims["email"].(string)
			ctx := context.WithValue(r.Context(), firebaseUIDContextKey, token.UID)
			ctx = context.WithValue(ctx, emailContextKey, email)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// AuthMiddleware verifies the Firebase ID token and loads the user from the DB.
// Returns 403 if the user is not registered.
func AuthMiddleware(firebaseApp *firebase.App, db *gorm.DB) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			idToken, ok := extractBearerToken(r)
			if !ok {
				respond.RespondError(w, http.StatusUnauthorized, "missing token")
				return
			}

			client, err := firebaseApp.Auth(r.Context())
			if err != nil {
				respond.RespondError(w, http.StatusInternalServerError, "firebase auth unavailable")
				return
			}

			token, err := client.VerifyIDToken(r.Context(), idToken)
			if err != nil {
				respond.RespondError(w, http.StatusUnauthorized, "invalid token")
				return
			}

			var user models.User
			if err := db.Where("firebase_uid = ?", token.UID).First(&user).Error; err != nil {
				respond.RespondError(w, http.StatusForbidden, "user not registered")
				return
			}

			ctx := context.WithValue(r.Context(), UserContextKey, &user)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// AdminMiddleware checks that the authenticated user has the 'admin' role.
// Must be used after AuthMiddleware.
func AdminMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		user, ok := UserFromContext(r.Context())
		if !ok || user.Role != "admin" {
			respond.RespondError(w, http.StatusForbidden, "admin only")
			return
		}
		next.ServeHTTP(w, r)
	})
}

func UserFromContext(ctx context.Context) (*models.User, bool) {
	user, ok := ctx.Value(UserContextKey).(*models.User)
	return user, ok
}

func FirebaseUIDFromContext(ctx context.Context) (string, string) {
	uid, _ := ctx.Value(firebaseUIDContextKey).(string)
	email, _ := ctx.Value(emailContextKey).(string)
	return uid, email
}

func extractBearerToken(r *http.Request) (string, bool) {
	h := r.Header.Get("Authorization")
	if !strings.HasPrefix(h, "Bearer ") {
		return "", false
	}
	return strings.TrimPrefix(h, "Bearer "), true
}
