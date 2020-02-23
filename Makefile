PGHOST?=localhost
PGPORT?=5432
PGUSER?=postgres
PGPASSWORD?=postgres
PGDATABASE?=postgres
PGSSLMODE?=disable
DATABASE_URL ?= "postgres://${PGUSER}:${PGPASSWORD}@${PGHOST}:${PGPORT}/${PGDATABASE}?sslmode=${PGSSLMODE}"
DUMPFILE ?= "db/dev-db.sql"

run-db:
	docker run -d --name ePantryPostgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres

start-db:
	docker start ePantryPostgress

stop-db:
	docker stop ePantryPostgress

apply_migrations:
	migrate -database ${DATABASE_URL} -path db/migrations up

load-database:
	psql -f ${DUMPFILE}

dump-database:
	pg_dump --schema=public --inserts --clean --if-exists --file=${DUMPFILE}

.PHONY: deps clean build

deps:
	go get -u ./...

clean:
	rm -rf ./ePantry/ePantry

build:
	GOOS=linux GOARCH=amd64 go build -o ePantry/ePantry ./ePantry
	mkdir -p bin
	go build -o bin/local ./cmd/ePantry

deploy: build
	sam deploy

run-local: build
	./bin/local

xo-gen:
	@mkdir -p pkg/models
	@xo ${DATABASE_URL} -o pkg/models
