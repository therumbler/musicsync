.PHONY: build run test

build:
	docker build -t musicsync .

run: build
	docker run musicsync

test:
	docker run musicsync