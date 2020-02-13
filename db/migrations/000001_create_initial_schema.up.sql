CREATE TABLE IF NOT EXISTS items
(
    id                   SERIAL PRIMARY KEY,
    name                 TEXT UNIQUE NOT NULL,
    notes                TEXT,
    cost_per_kilogram    DOUBLE PRECISION,
    fats_per_kilogram    DOUBLE PRECISION,
    carbs_per_kilogram   DOUBLE PRECISION,
    protein_per_kilogram DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS food_recipes
(
    id        SERIAL PRIMARY KEY,
    name      TEXT    NOT NULL,
    group_id  INTEGER NOT NULL, -- e.g. day 1, 2, etc.
    meal_type TEXT    NOT NULL, -- e.g. breakfast, brunch, lunch, dinner,
    notes     TEXT    NOT NULL  -- preparation notes etc
);

CREATE TABLE IF NOT EXISTS food_diary
(
    id        SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES food_recipes (id),
    time      TIMESTAMP,
    notes     TEXT
);


CREATE TABLE IF NOT EXISTS food_recipe_item
(
    id              SERIAL PRIMARY KEY,
    recipe_id       INTEGER          NOT NULL REFERENCES food_recipes (id),
    item_id         INTEGER          NOT NULL REFERENCES items (id),
    amount_kilogram DOUBLE PRECISION NOT NULL,
    notes           TEXT
)
