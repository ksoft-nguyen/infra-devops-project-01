SHELL := /bin/sh

RESOURCE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

COMPOSE ?= docker compose
PROJECT ?= mern-todo
SERVICE ?=

ENV_FILE ?= $(RESOURCE_DIR)/.env
ENV_EXAMPLE ?= $(RESOURCE_DIR)/.env.example

DEV_COMPOSE_FILE := $(RESOURCE_DIR)/docker-compose.yml
PROD_COMPOSE_FILE := $(RESOURCE_DIR)/docker-compose.prod.yml

DEV_COMPOSE = $(COMPOSE) --env-file "$(ENV_FILE)" -f "$(DEV_COMPOSE_FILE)" -p "$(PROJECT)-dev"
PROD_COMPOSE = $(COMPOSE) --env-file "$(ENV_FILE)" -f "$(PROD_COMPOSE_FILE)" -p "$(PROJECT)-prod"

.DEFAULT_GOAL := help

.PHONY: help env urls validate \
	dev prod switch-dev switch-prod \
	dev-up prod-up dev-build prod-build dev-rebuild prod-rebuild \
	dev-down prod-down down dev-restart prod-restart restart \
	dev-logs prod-logs logs dev-ps prod-ps ps status \
	dev-config prod-config \
	dev-backend-shell dev-frontend-shell prod-backend-shell prod-frontend-shell \
	dev-reset prod-reset reset

help:
	@printf 'MERN Todo Makefile\n\n'
	@printf 'Usage:\n'
	@printf '  make dev                  Start DEV stack with hot reload and mongo-express\n'
	@printf '  make prod                 Start PROD stack with production Dockerfiles\n'
	@printf '  make switch-dev           Stop PROD, then start DEV\n'
	@printf '  make switch-prod          Stop DEV, then start PROD\n'
	@printf '  make down                 Stop both stacks without deleting volumes\n'
	@printf '  make status               Show DEV and PROD container status\n'
	@printf '  make logs SERVICE=backend Follow logs; omit SERVICE for all services\n'
	@printf '  make dev-logs             Follow DEV logs\n'
	@printf '  make prod-logs            Follow PROD logs\n'
	@printf '  make validate             Validate both compose files\n'
	@printf '  make urls                 Print configured local URLs\n\n'
	@printf 'Examples:\n'
	@printf '  make dev\n'
	@printf '  make prod-logs SERVICE=frontend\n'
	@printf '  make dev-backend-shell\n\n'
	@printf 'Variables:\n'
	@printf '  COMPOSE="%s"\n' '$(COMPOSE)'
	@printf '  PROJECT="%s"\n' '$(PROJECT)'
	@printf '  ENV_FILE="%s"\n' '$(ENV_FILE)'

$(ENV_FILE):
	@printf 'Creating %s from %s\n' "$(ENV_FILE)" "$(ENV_EXAMPLE)"
	@cp "$(ENV_EXAMPLE)" "$(ENV_FILE)"

env: $(ENV_FILE)
	@printf 'Using env file: %s\n' "$(ENV_FILE)"

urls: env
	@frontend_port="$$(awk -F= '/^EXTERNAL_FRONTEND_PORT=/{value=$$2} END{print value}' "$(ENV_FILE)")"; \
	backend_port="$$(awk -F= '/^EXTERNAL_BACKEND_PORT=/{value=$$2} END{print value}' "$(ENV_FILE)")"; \
	frontend_port="$${frontend_port:-3000}"; \
	backend_port="$${backend_port:-8000}"; \
	printf 'Frontend:          http://localhost:%s\n' "$$frontend_port"; \
	printf 'Backend API:       http://localhost:%s/api\n' "$$backend_port"; \
	printf 'Mongo Express DEV: http://localhost:8081\n'

validate: env
	@$(DEV_COMPOSE) config >/dev/null
	@$(PROD_COMPOSE) config >/dev/null
	@printf 'Compose files are valid.\n'

dev: dev-up

prod: prod-up

switch-dev: prod-down dev-up

switch-prod: dev-down prod-up

dev-up: env
	@$(DEV_COMPOSE) up -d --build
	@$(MAKE) -f "$(abspath $(lastword $(MAKEFILE_LIST)))" urls

prod-up: env
	@$(PROD_COMPOSE) up -d --build
	@$(MAKE) -f "$(abspath $(lastword $(MAKEFILE_LIST)))" urls

dev-build: env
	@$(DEV_COMPOSE) build

prod-build: env
	@$(PROD_COMPOSE) build

dev-rebuild: env
	@$(DEV_COMPOSE) build --no-cache

prod-rebuild: env
	@$(PROD_COMPOSE) build --no-cache

dev-down:
	@$(DEV_COMPOSE) down --remove-orphans

prod-down:
	@$(PROD_COMPOSE) down --remove-orphans

down: dev-down prod-down

dev-restart: env
	@$(DEV_COMPOSE) restart $(SERVICE)

prod-restart: env
	@$(PROD_COMPOSE) restart $(SERVICE)

restart: dev-restart

dev-logs: env
	@$(DEV_COMPOSE) logs -f $(SERVICE)

prod-logs: env
	@$(PROD_COMPOSE) logs -f $(SERVICE)

logs: dev-logs

dev-ps: env
	@$(DEV_COMPOSE) ps

prod-ps: env
	@$(PROD_COMPOSE) ps

ps: status

status: env
	@printf 'DEV stack:\n'
	@$(DEV_COMPOSE) ps
	@printf '\nPROD stack:\n'
	@$(PROD_COMPOSE) ps

dev-config: env
	@$(DEV_COMPOSE) config

prod-config: env
	@$(PROD_COMPOSE) config

dev-backend-shell: env
	@$(DEV_COMPOSE) exec backend sh

dev-frontend-shell: env
	@$(DEV_COMPOSE) exec frontend sh

prod-backend-shell: env
	@$(PROD_COMPOSE) exec backend sh

prod-frontend-shell: env
	@$(PROD_COMPOSE) exec frontend sh

dev-reset:
	@printf 'Removing DEV containers, networks, and volumes...\n'
	@$(DEV_COMPOSE) down -v --remove-orphans

prod-reset:
	@printf 'Removing PROD containers, networks, and volumes...\n'
	@$(PROD_COMPOSE) down -v --remove-orphans

reset: dev-reset prod-reset
