package cli

import (
	_ "github.com/lib/pq"
	"github.com/spf13/cobra"

	"github.com/nmiculinic/ePantry/pkg/cli/generate"
	"github.com/nmiculinic/ePantry/pkg/cli/todoist"
)

func NewLocalServerCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use: "ePantry",
	}
	cmd.AddCommand(
		generate.NewGenerateCommand(),
		todoist.NewCommand(),
	)
	return cmd
}
