// Package models contains the types for schema 'public'.
package models

// Code generated by xo. DO NOT EDIT.

import (
	"database/sql"
	"errors"
)

// Item represents a row from 'public.items'.
type Item struct {
	ID                 int             `json:"id"`                   // id
	Name               string          `json:"name"`                 // name
	Notes              sql.NullString  `json:"notes"`                // notes
	CostPerKilogram    sql.NullFloat64 `json:"cost_per_kilogram"`    // cost_per_kilogram
	FatsPerKilogram    sql.NullFloat64 `json:"fats_per_kilogram"`    // fats_per_kilogram
	CarbsPerKilogram   sql.NullFloat64 `json:"carbs_per_kilogram"`   // carbs_per_kilogram
	ProteinPerKilogram sql.NullFloat64 `json:"protein_per_kilogram"` // protein_per_kilogram

	// xo fields
	_exists, _deleted bool
}

// Exists determines if the Item exists in the database.
func (i *Item) Exists() bool {
	return i._exists
}

// Deleted provides information if the Item has been deleted from the database.
func (i *Item) Deleted() bool {
	return i._deleted
}

// Insert inserts the Item to the database.
func (i *Item) Insert(db XODB) error {
	var err error

	// if already exist, bail
	if i._exists {
		return errors.New("insert failed: already exists")
	}

	// sql insert query, primary key provided by sequence
	const sqlstr = `INSERT INTO public.items (` +
		`name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram` +
		`) VALUES (` +
		`$1, $2, $3, $4, $5, $6` +
		`) RETURNING id`

	// run query
	XOLog(sqlstr, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram)
	err = db.QueryRow(sqlstr, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram).Scan(&i.ID)
	if err != nil {
		return err
	}

	// set existence
	i._exists = true

	return nil
}

// Update updates the Item in the database.
func (i *Item) Update(db XODB) error {
	var err error

	// if doesn't exist, bail
	if !i._exists {
		return errors.New("update failed: does not exist")
	}

	// if deleted, bail
	if i._deleted {
		return errors.New("update failed: marked for deletion")
	}

	// sql query
	const sqlstr = `UPDATE public.items SET (` +
		`name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram` +
		`) = ( ` +
		`$1, $2, $3, $4, $5, $6` +
		`) WHERE id = $7`

	// run query
	XOLog(sqlstr, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram, i.ID)
	_, err = db.Exec(sqlstr, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram, i.ID)
	return err
}

// Save saves the Item to the database.
func (i *Item) Save(db XODB) error {
	if i.Exists() {
		return i.Update(db)
	}

	return i.Insert(db)
}

// Upsert performs an upsert for Item.
//
// NOTE: PostgreSQL 9.5+ only
func (i *Item) Upsert(db XODB) error {
	var err error

	// if already exist, bail
	if i._exists {
		return errors.New("insert failed: already exists")
	}

	// sql query
	const sqlstr = `INSERT INTO public.items (` +
		`id, name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram` +
		`) VALUES (` +
		`$1, $2, $3, $4, $5, $6, $7` +
		`) ON CONFLICT (id) DO UPDATE SET (` +
		`id, name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram` +
		`) = (` +
		`EXCLUDED.id, EXCLUDED.name, EXCLUDED.notes, EXCLUDED.cost_per_kilogram, EXCLUDED.fats_per_kilogram, EXCLUDED.carbs_per_kilogram, EXCLUDED.protein_per_kilogram` +
		`)`

	// run query
	XOLog(sqlstr, i.ID, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram)
	_, err = db.Exec(sqlstr, i.ID, i.Name, i.Notes, i.CostPerKilogram, i.FatsPerKilogram, i.CarbsPerKilogram, i.ProteinPerKilogram)
	if err != nil {
		return err
	}

	// set existence
	i._exists = true

	return nil
}

// Delete deletes the Item from the database.
func (i *Item) Delete(db XODB) error {
	var err error

	// if doesn't exist, bail
	if !i._exists {
		return nil
	}

	// if deleted, bail
	if i._deleted {
		return nil
	}

	// sql query
	const sqlstr = `DELETE FROM public.items WHERE id = $1`

	// run query
	XOLog(sqlstr, i.ID)
	_, err = db.Exec(sqlstr, i.ID)
	if err != nil {
		return err
	}

	// set deleted
	i._deleted = true

	return nil
}

// ItemByName retrieves a row from 'public.items' as a Item.
//
// Generated from index 'items_name_key'.
func ItemByName(db XODB, name string) (*Item, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`id, name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram ` +
		`FROM public.items ` +
		`WHERE name = $1`

	// run query
	XOLog(sqlstr, name)
	i := Item{
		_exists: true,
	}

	err = db.QueryRow(sqlstr, name).Scan(&i.ID, &i.Name, &i.Notes, &i.CostPerKilogram, &i.FatsPerKilogram, &i.CarbsPerKilogram, &i.ProteinPerKilogram)
	if err != nil {
		return nil, err
	}

	return &i, nil
}

// ItemByID retrieves a row from 'public.items' as a Item.
//
// Generated from index 'items_pkey'.
func ItemByID(db XODB, id int) (*Item, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`id, name, notes, cost_per_kilogram, fats_per_kilogram, carbs_per_kilogram, protein_per_kilogram ` +
		`FROM public.items ` +
		`WHERE id = $1`

	// run query
	XOLog(sqlstr, id)
	i := Item{
		_exists: true,
	}

	err = db.QueryRow(sqlstr, id).Scan(&i.ID, &i.Name, &i.Notes, &i.CostPerKilogram, &i.FatsPerKilogram, &i.CarbsPerKilogram, &i.ProteinPerKilogram)
	if err != nil {
		return nil, err
	}

	return &i, nil
}
