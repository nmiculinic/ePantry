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

.PHONY: deps build

clean:
	rm -Rf ./ePantry/ePantry
	rm -Rf ./bin
.PHONY: clean

build:
	mkdir -p bin
	GOOS=linux GOARCH=amd64 go build -o ./bin/api-lambda ./cmd/lambda
	go build -o bin/ePantry ./cmd/ePantry
	go build -o bin/apiserver ./cmd/local-apiserver
.PHONY: build

deploy: build
	sam deploy
.PHONY: deploy

xo-gen:
	@mkdir -p pkg/models
	@xo ${DATABASE_URL} -o pkg/models

proto-gen:
	protoc \
    --go_out=plugins=grpc:$(PWD)/pkg/api/v1 \
    --grpc-gateway_out=logtostderr=true:$(PWD)/pkg/api/v1 \
    -I/usr/include \
    -I=$(PWD)/pkg/api/v1  \
    $(PWD)/pkg/api/v1/epantry.proto

creds:
	echo "run\n source <(lpass show ePantry --notes)"
.PHONY: creds
