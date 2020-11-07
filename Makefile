.PHONY: build run test

build:
	docker build -t musicsync .

run: build
	docker run -e TIDAL_TOKEN=${TIDAL_TOKEN} -p 2345:2345 musicsync

test:
	docker run -e TIDAL_TOKEN=${TIDAL_TOKEN} musicsync