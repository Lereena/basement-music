package config

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"io"
	"os"
)

// secretKey derives a 32-byte AES key from the SLSK_SECRET env var via SHA-256.
// Any non-empty secret is accepted; the hash guarantees a valid 32-byte key.
func secretKey() ([]byte, error) {
	secret := os.Getenv("SLSK_SECRET")
	if secret == "" {
		return nil, errors.New("SLSK_SECRET not configured")
	}
	sum := sha256.Sum256([]byte(secret))
	return sum[:], nil
}

// SecretConfigured reports whether SLSK_SECRET is set.
func SecretConfigured() bool {
	return os.Getenv("SLSK_SECRET") != ""
}

// Encrypt seals plain with AES-256-GCM and returns base64(nonce || ciphertext).
func Encrypt(plain string) (string, error) {
	key, err := secretKey()
	if err != nil {
		return "", err
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return "", err
	}
	sealed := gcm.Seal(nonce, nonce, []byte(plain), nil)
	return base64.StdEncoding.EncodeToString(sealed), nil
}

// Decrypt reverses Encrypt.
func Decrypt(enc string) (string, error) {
	key, err := secretKey()
	if err != nil {
		return "", err
	}
	raw, err := base64.StdEncoding.DecodeString(enc)
	if err != nil {
		return "", err
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}
	if len(raw) < gcm.NonceSize() {
		return "", errors.New("ciphertext too short")
	}
	nonce, ciphertext := raw[:gcm.NonceSize()], raw[gcm.NonceSize():]
	plain, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return "", err
	}
	return string(plain), nil
}
