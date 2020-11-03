.PHONY: build run

build:
	docker build -t musicsync .

run: build
	docker run musicsync 