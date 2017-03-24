package common

import (
	"os"
	"path/filepath"
	"runtime"
)

var (
	// Convenience directories.
	MonaxRoot          = ResolveMonaxRoot()
	MonaxContainerRoot = "/home/eris/.eris"

	// Major directories.
	KeysPath    = filepath.Join(MonaxRoot, "keys")
	ScratchPath = filepath.Join(MonaxRoot, "scratch")
)

func HomeDir() string {
	if runtime.GOOS == "windows" {
		drive := os.Getenv("HOMEDRIVE")
		path := os.Getenv("HOMEPATH")
		if drive == "" || path == "" {
			return os.Getenv("USERPROFILE")
		}
		return drive + path
	} else {
		return os.Getenv("HOME")
	}
}

func ResolveMonaxRoot() string {
	var eris string
	if os.Getenv("ERIS") != "" {
		eris = os.Getenv("ERIS")
	} else {
		if runtime.GOOS == "windows" {
			home := os.Getenv("HOMEDRIVE") + os.Getenv("HOMEPATH")
			if home == "" {
				home = os.Getenv("USERPROFILE")
			}
			eris = filepath.Join(home, ".eris")
		} else {
			eris = filepath.Join(HomeDir(), ".eris")
		}
	}
	return eris
}
