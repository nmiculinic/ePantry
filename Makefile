DATABASE_URL?='postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable'

run-db:
	docker run -d --name ePantryPostgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres

start-db:
	docker start ePantryPostgress

stop-db:
	docker stop ePantryPostgress

apply_migrations:
	migrate -database ${DATABASE_URL} -path db/migrations up

load-dev-database:
	psql -d postgres -h localhost -U postgres -f db/dev-db.sql

dump-dev-database:
	pg_dump --dbname=postgres --schema=public --inserts --clean --if-exists --file=db/dev-db.sql --username=postgres --host=localhost --port=5432

.PHONY: deps clean build

deps:
	go get -u ./...

clean:
	rm -rf ./ePantry/ePantry

build:
	GOOS=linux GOARCH=amd64 go build -o ePantry/ePantry ./ePantry
