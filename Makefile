include .env

.PHONY: up down stop prune ps shell drush logs init dbdump

default: up

PROJECT_NAME ?= kti

init:
	docker network create internal >/dev/null 2>&1

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

down: stop

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	docker-compose stop

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	docker-compose down

ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='kti_php' --format "{{ .ID }}") bash

logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

%:
	@:
