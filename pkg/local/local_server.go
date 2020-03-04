package local

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/lib/pq"
	_ "github.com/lib/pq"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/xo/dburl"

	"github.com/nmiculinic/ePantry/pkg/models"
)

type Config struct {
	DatabaseURL string
	StartDate   string
	EndDate     string
	DryRun      bool
}

func NewLocalServerCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use: "ePantry",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg := &Config{}
			if err := viper.Unmarshal(cfg); err != nil {
				return fmt.Errorf("cannot unmarshall: %w", err)
			}
			return runE(cfg)
		},
	}

	cmd.Flags().Bool("dry-run", false, "dry run")
	cmd.Flags().String("start-date", "", "start date for food diary entry generation")
	cmd.Flags().String("end-date", "", "end date for food diary entry generation")
	cmd.Flags().String("database-url", "", "database url. Can be loaded via env DATABASE_URL")
	must(viper.BindPFlag("databaseURL", cmd.Flag("database-url")))
	must(viper.BindPFlag("dryRun", cmd.Flag("dry-run")))
	must(viper.BindPFlag("startDate", cmd.Flag("start-date")))
	must(viper.BindPFlag("endDate", cmd.Flag("end-date")))
	must(viper.BindEnv("databaseURL", "DATABASE_URL"))
	return cmd
}

func runE(cfg *Config) error {
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

	rows, err := db.Query(`
SELECT id, recipe_id, time, notes
FROM food_diary
`)
	if err != nil {
		return fmt.Errorf("query %w", err)
	}
	defer rows.Close()

	diary := make(map[time.Time]struct{})
	for rows.Next() {
		item := &models.FoodDiary{}
		err := rows.Scan(&item.ID, &item.RecipeID, &item.Time, &item.Notes)
		if err != nil {
			return fmt.Errorf("scanning rows: %w", err)
		}
		diary[toDayOnly(item.Time.Time)] = struct{}{}
	}
	if err = rows.Err(); err != nil {
		return fmt.Errorf("reading rows: %w", err)
	}

	items := make([]*models.FoodDiary, 0)
	offset := 7
	for day := startDate; day.Before(endDate); day = day.Add(24 * time.Hour) {
		day = toDayOnly(day)
		if _, present := diary[day]; present {
			logrus.Warn("day present ", day)
			continue
		}

		dayId := 1 + (((day.YearDay() + offset) % 10) / 2)
		for i, timeOfDay := range []time.Duration{
			7 * time.Hour,
			10 * time.Hour,
			14 * time.Hour,
			17 * time.Hour,
			20 * time.Hour,
		} {
			items = append(items, &models.FoodDiary{
				RecipeID: sql.NullInt64{
					Valid: true,
					Int64: int64(10*dayId + i + 1),
				},
				Time: pq.NullTime{
					Time:  day.Add(timeOfDay),
					Valid: true,
				},
				Notes: sql.NullString{},
			})
		}
		logrus.Infof("preparing to insert day %d for %v", dayId, day)
	}

	if !cfg.DryRun {
		for _, it := range items {
			if err := it.Save(db); err != nil {
				return fmt.Errorf("saving db %w", err)
			}
		}
		logrus.Info("saved all items to the database")
	} else {
		logrus.Warn("dry-run mode, skipping inserting items in db")
	}

	return nil
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}

func toDayOnly(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, time.UTC)
}
