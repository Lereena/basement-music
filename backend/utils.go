package main

import "regexp"

const splitSymbols = `[-−‐‑‒–—―]`

var dashRegexp = regexp.MustCompile(splitSymbols)

// canonicalizeDashes folds every dash variant to a plain hyphen so filenames
// that differ only by dash character (e.g. "Artist - Song" vs "Artist — Song")
// collapse to the same canonical form. Used to dedup tracks by song identity.
func canonicalizeDashes(s string) string {
	return dashRegexp.ReplaceAllString(s, "-")
}
