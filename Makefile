.PHONY: build run test

build:
	docker build -t musicsync .

run: build
	docker run -e TIDAL_TOKEN=${TIDAL_TOKEN} musicsync

test:
	docker run musicsync