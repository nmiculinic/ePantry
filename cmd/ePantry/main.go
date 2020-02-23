package main

import (
	"log"

	"github.com/nmiculinic/ePantry/pkg/local"
)

func main() {
	if err := local.NewLocalServerCommand().Execute(); err != nil {
		log.Panic(err)
	}
}
