SHELL := /bin/bash
-include .env
DOCKER_IMAGE_NAME ?= week5-class2-demo
TAG ?= local
export DOCKER_IMAGE_NAME
export TAG
.DEFAULT_GOAL := help
.PHONY: help lint build run test push down clean
help:
	@echo "make lint - Check Dockerfile"
	@echo "make build - Build Docker image"
	@echo "make run - Start Docker container"
	@echo "make test - Test HTTP endpoint"
	@echo "make push - Push Docker image to ecr"
	@echo "make down - Stop Docker container"
	@echo "make clean - Remove Docker image"
lint:
	docker run --rm -i hadolint/hadolint < Dockerfile || true
build:
	docker build -t $(DOCKER_IMAGE_NAME):$(TAG) .
run:
	docker compose up -d --wait --wait-timeout 60
test:
	curl --fail --show-error http://127.0.0.1:5000/
push:
	docker push "$(DOCKER_IMAGE_NAME):$(TAG)"
down:
	docker compose down --remove-orphans
	