package main

import (
	"log"

	"github.com/nmiculinic/ePantry/pkg/cli"
)

func main() {
	if err := cli.NewLocalServerCommand().Execute(); err != nil {
		log.Panic(err)
	}
}
