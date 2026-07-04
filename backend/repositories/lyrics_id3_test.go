package repositories

import (
	"io"
	"os"
	"path/filepath"
	"testing"
)

func TestUSLTRoundTrip(t *testing.T) {
	src := filepath.Join("..", "music", "KUUMAA - Kolme toivetta.mp3")
	if _, err := os.Stat(src); err != nil {
		t.Skipf("sample mp3 unavailable: %v", err)
	}

	tmp := filepath.Join(t.TempDir(), "sample.mp3")
	copyFile(t, src, tmp)

	lrc := "[00:01.00]First line\n[00:05.50]Second line"
	if err := writeUSLT(tmp, lrc); err != nil {
		t.Fatalf("writeUSLT: %v", err)
	}

	got, err := readUSLT(tmp)
	if err != nil {
		t.Fatalf("readUSLT: %v", err)
	}
	if got != lrc {
		t.Fatalf("round-trip mismatch: got %q want %q", got, lrc)
	}

	if !lrcTimestampRe.MatchString(got) {
		t.Fatal("expected LRC timestamp detection to match")
	}
}

func copyFile(t *testing.T, src, dst string) {
	t.Helper()
	in, err := os.Open(src)
	if err != nil {
		t.Fatal(err)
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		t.Fatal(err)
	}
	defer out.Close()
	if _, err := io.Copy(out, in); err != nil {
		t.Fatal(err)
	}
}
