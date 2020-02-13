DATABASE_URL?='postgres://postgres@localhost:5432/postgres?sslmode=disable'

setup:
	docker run -it --name ePantryPostgres -p 5432:5432 postgres

apply_migrations:
	migrate -database ${DATABASE_URL} -path db/migrations up
