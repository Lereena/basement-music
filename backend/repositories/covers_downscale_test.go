package repositories

import (
	"bytes"
	"image"
	"image/color"
	"image/png"
	"math/rand"
	"testing"
)

// noisyPNG renders a size×size PNG of random pixels so it does not compress away
// to a few bytes — a realistic stand-in for a large uploaded cover.
func noisyPNG(t *testing.T, size int) []byte {
	t.Helper()
	img := image.NewRGBA(image.Rect(0, 0, size, size))
	rng := rand.New(rand.NewSource(1))
	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			img.Set(x, y, color.RGBA{uint8(rng.Intn(256)), uint8(rng.Intn(256)), uint8(rng.Intn(256)), 255})
		}
	}
	var buf bytes.Buffer
	if err := png.Encode(&buf, img); err != nil {
		t.Fatalf("encode noisy png: %v", err)
	}
	return buf.Bytes()
}

func TestDownscaleCoverEnforcesByteCap(t *testing.T) {
	big := noisyPNG(t, 1500)
	if len(big) <= maxCoverBytes {
		t.Fatalf("test fixture too small: %d bytes, need > %d", len(big), maxCoverBytes)
	}

	out := downscaleCover(big)
	if len(out) > maxCoverBytes {
		t.Fatalf("downscaled cover exceeds cap: got %d bytes, want <= %d", len(out), maxCoverBytes)
	}
	if _, _, err := image.Decode(bytes.NewReader(out)); err != nil {
		t.Fatalf("downscaled cover is not a decodable image: %v", err)
	}
}

func TestDownscaleCoverKeepsSmallInputUntouched(t *testing.T) {
	small := noisyPNG(t, 64)
	if len(small) > maxCoverBytes {
		t.Skipf("fixture unexpectedly large: %d bytes", len(small))
	}

	out := downscaleCover(small)
	if !bytes.Equal(out, small) {
		t.Fatalf("small input was modified: got %d bytes, want %d unchanged", len(out), len(small))
	}
}

func TestDownscaleCoverPassesThroughUndecodable(t *testing.T) {
	// Over the cap but not a valid image: embed as-is rather than drop it.
	junk := bytes.Repeat([]byte{0xAB}, maxCoverBytes+1)
	out := downscaleCover(junk)
	if !bytes.Equal(out, junk) {
		t.Fatalf("undecodable input should pass through unchanged")
	}
}
