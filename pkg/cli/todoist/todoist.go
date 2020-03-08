package todoist

import (
	"context"
	"fmt"
	"strings"
	"time"
	"unicode"

	todoist "github.com/sachaos/todoist/lib"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/xo/dburl"
)

type Config struct {
	DatabaseURL  string
	StartDate    string
	EndDate      string
	DryRun       bool
	TodoistToken string
	ProjectName  string
}

func NewCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use: "todoist",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg := &Config{}
			if err := viper.Unmarshal(cfg); err != nil {
				return fmt.Errorf("cannot unmarshall: %w", err)
			}
			client := todoist.NewClient(&todoist.Config{
				AccessToken: cfg.TodoistToken,
			})
			ctx, cancel := context.WithCancel(context.Background())
			defer cancel()

			if err := client.Sync(ctx); err != nil {
				return err
			}

			projectID, err := getProjectId(client, cfg)
			if err != nil {
				return err
			}

			existingItems := make(map[string]int)
			for _, it := range client.Store.Items {
				if it.ProjectID == projectID {
					var itemName string
					numID := strings.IndexFunc(it.BaseItem.Content, unicode.IsNumber)
					if numID > 0 {
						itemName = strings.TrimSpace(it.BaseItem.Content[:numID])
					} else {
						itemName = strings.TrimSpace(it.BaseItem.Content)
					}
					existingItems[itemName] = it.ID
				}
			}

			startDate, err := time.Parse("2006-01-02", cfg.StartDate)
			if err != nil {
				return fmt.Errorf("parsing date: %w", err)
			}
			endDate, err := time.Parse("2006-01-02", cfg.EndDate)
			if err != nil {
				return fmt.Errorf("parsing date: %w", err)
			}
			db, err := dburl.Open(cfg.DatabaseURL)
			if err != nil {
				return fmt.Errorf("opening dburl: %w", err)
			}
			defer db.Close()

			rows, err := db.QueryContext(ctx, `
SELECT
    items.name,
    -- food_recipe_item.amount_kilogram
    SUM(food_recipe_item.amount_kilogram) * 1000.0 AS "g",
    COUNT(*)                                       AS "times repeated"
FROM food_diary,
     food_recipes,
     food_recipe_item,
     items
WHERE food_diary.recipe_id = food_recipes.id
  AND food_recipes.id = food_recipe_item.recipe_id
  AND items.id = food_recipe_item.item_id
  AND food_diary.time > $1
  AND food_diary.time < $2
GROUP BY items.id
ORDER BY items.name
`, startDate, endDate)
			if err != nil {
				return err
			}
			commands := make([]todoist.Command, 0)
			for rows.Next() {
				var (
					name        string
					amount      float64
					numRepeated int
				)
				if err := rows.Scan(&name, &amount, &numRepeated); err != nil {
					return err
				}
				wanted := fmt.Sprintf("%s %.2fg [%d servings]", name, amount, numRepeated)
				if itId, ok := existingItems[name]; ok {
					it := *client.Store.ItemMap[itId]
					it.BaseItem.Content = wanted
					commands = append(commands,
						todoist.NewCommand("item_update", it.UpdateParam()),
					)
					logrus.Infof("%s queued for update", name)
				} else {
					commands = append(commands,
						todoist.NewCommand("item_add", todoist.Item{
							BaseItem: todoist.BaseItem{
								HaveID: todoist.HaveID{},
								HaveProjectID: todoist.HaveProjectID{
									ProjectID: projectID,
								},
								Content: wanted,
								UserID:  0,
							},
						}.AddParam()),
					)
					logrus.Infof("%s queued for insertion", name)
				}
			}
			if err := client.ExecCommands(ctx, commands); err != nil {
				return err
			}
			logrus.Infof("successfully applied %d commands", len(commands))
			return nil
		},
	}

	cmd.Flags().Bool("dry-run", false, "dry run")
	cmd.Flags().String("start-date", time.Now().Format("2006-01-02"), "start date for food diary entry generation")
	cmd.Flags().String("end-date", time.Now().Add(14*24*time.Hour).Format("2006-01-02"), "end date for food diary entry generation")
	cmd.Flags().String("database-url", "", "database url. Can be loaded via env DATABASE_URL")
	cmd.Flags().String("todoist-token", "", "todoist tokken Can be loaded via env TODOIST_TOKEN")
	cmd.Flags().String("project-name", "Groceries", "project name in todoist where to put food items")
	must(viper.BindPFlag("databaseURL", cmd.Flag("database-url")))
	must(viper.BindPFlag("dryRun", cmd.Flag("dry-run")))
	must(viper.BindPFlag("startDate", cmd.Flag("start-date")))
	must(viper.BindPFlag("endDate", cmd.Flag("end-date")))
	must(viper.BindPFlag("projectName", cmd.Flag("project-name")))
	must(viper.BindEnv("databaseURL", "DATABASE_URL"))
	must(viper.BindEnv("todoistToken", "TODOIST_TOKEN"))
	return cmd
}

func getProjectId(client *todoist.Client, cfg *Config) (int, error) {
	var projectID int
	for _, project := range client.Store.Projects {
		if cfg.ProjectName == project.Name {
			projectID = project.ID
		}
	}
	if projectID == 0 {
		return 0, fmt.Errorf("project %s not found", cfg.ProjectName)
	}
	return projectID, nil
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}
