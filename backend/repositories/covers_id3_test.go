package repositories

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"
)

// Minimal valid PNG (1x1) — enough for MIME detection and byte comparison.
var testPNG = []byte{
	0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
	0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
	0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
	0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
	0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
	0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
	0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
	0x42, 0x60, 0x82,
}

func TestAPICRoundTrip(t *testing.T) {
	src := filepath.Join("..", "music", "KUUMAA - Kolme toivetta.mp3")
	if _, err := os.Stat(src); err != nil {
		t.Skipf("sample mp3 unavailable: %v", err)
	}

	tmp := filepath.Join(t.TempDir(), "sample.mp3")
	copyFile(t, src, tmp)

	if err := writeAPIC(tmp, testPNG); err != nil {
		t.Fatalf("writeAPIC: %v", err)
	}

	got, mimeType, err := readAPIC(tmp)
	if err != nil {
		t.Fatalf("readAPIC: %v", err)
	}
	if !bytes.Equal(got, testPNG) {
		t.Fatalf("round-trip mismatch: got %d bytes, want %d", len(got), len(testPNG))
	}
	if mimeType != "image/png" {
		t.Fatalf("mime mismatch: got %q want image/png", mimeType)
	}

	// Replacing the picture must not stack a second APIC frame.
	if err := writeAPIC(tmp, testPNG); err != nil {
		t.Fatalf("second writeAPIC: %v", err)
	}
	got, _, err = readAPIC(tmp)
	if err != nil || !bytes.Equal(got, testPNG) {
		t.Fatalf("re-write round-trip failed: err=%v", err)
	}
}
