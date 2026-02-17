.PHONY: build test lint fmt run

build: fmt lint test
	go build .

test:
	go test -race ./...

lint:
	golangci-lint run

fmt:
	go mod tidy
	go fix ./...
	gofumpt -w .

run:
	go run .
