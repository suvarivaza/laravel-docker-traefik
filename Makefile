# Compose parses .env itself; Laravel dotenv files are not Make syntax.
COMPOSE = docker compose --env-file .env
COMMAND := $(firstword $(MAKECMDGOALS))
ARGS ?= $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

#============= Help ===============#
.PHONY: help
ifeq ($(filter help,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
help:
	@echo ======= Help =======
	@echo 'You can pass the third parameter to the make command like this: make up php'
	@grep -h -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'
endif

.DEFAULT_GOAL := help


#============= Init ===============#
ifeq ($(filter init-dev,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
init-dev: ## Init dev environments
	@test ! -e .env || { echo ".env already exists; edit it or move it first."; exit 1; }
	cp .env.dev .env
endif

ifeq ($(filter init-prod,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
init-prod: ## Init prod environments
	@test ! -e .env || { echo ".env already exists; edit it or move it first."; exit 1; }
	cp .env.prod .env
endif

#============= Start ===============#
ifeq ($(filter up,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
up: ## Start all services | up one service: make up php
	$(COMPOSE) up -d --build $(ARGS)
endif

ifeq ($(filter build,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
build: ## Build all services | build one service: make build php
	$(COMPOSE) build --no-cache $(ARGS)
endif

ifeq ($(filter restart,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
restart: ## Restart all services | restart one service: make restart php
	$(COMPOSE) restart $(ARGS)
endif

ifeq ($(filter hard-restart,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
hard-restart: ## Hard restart ALL services ($(MAKE) down && $(MAKE) up)
	$(MAKE) down && $(MAKE) up
endif

ifeq ($(filter stop,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
stop: ## Stop all services | stop one service: make stop php
	$(COMPOSE) stop $(ARGS)
endif

ifeq ($(filter connect,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
connect: ## Connect to service. Example: make connect php
	$(COMPOSE) exec $(ARGS) bash
endif

ifeq ($(filter connect-root,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
connect-root: ## Connect to service as root. Example: make connect-root php
	$(COMPOSE) exec -u 0 $(ARGS) bash
endif

ifeq ($(filter logs,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
logs: ## Logs all services | one service: make logs php
	$(COMPOSE) logs -f --tail=20 $(ARGS)
endif

ifeq ($(filter down,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
down: ## Delete all services | one service: make down php
	$(COMPOSE) down $(ARGS)
endif

ifeq ($(filter down-cont-vol,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
down-cont-vol: ## Delete all containers and volumes | one service: make down-cont-vol php
	$(COMPOSE) down -v $(ARGS)
endif

ifeq ($(filter down-cont-img,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
down-cont-img: ## Delete all containers and images | one service: make down-cont-img php
	$(COMPOSE) down --rmi all $(ARGS)
endif

ifeq ($(filter down-all,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
down-all: ## WARNING! Delete ALL! containers / networks / images / volumes | one service: make down-all php
	$(COMPOSE) down -v --rmi all $(ARGS)
endif

ifeq ($(filter ps,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
ps: ## Show containers.
	$(COMPOSE) ps
endif

ifeq ($(filter config,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
config: ## Show containers.
	$(COMPOSE) config
endif


#============= Laravel ===============#
ifeq ($(filter laravel-install,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
laravel-install: ## Install Laravel
	$(COMPOSE) exec php sh -eu -c 'test ! -e example-app; composer create-project laravel/laravel example-app; for entry in example-app/* example-app/.[!.]* example-app/..?*; do [ -e "$$entry" ] || [ -L "$$entry" ] || continue; name=$${entry##*/}; if [ -e "$$name" ] || [ -L "$$name" ]; then echo "Destination already exists: $$name" >&2; exit 1; fi; done; for entry in example-app/* example-app/.[!.]* example-app/..?*; do [ -e "$$entry" ] || [ -L "$$entry" ] || continue; mv "$$entry" .; done; rmdir example-app'
endif

ifeq ($(filter composer-install,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
composer-install: ## composer install
	$(COMPOSE) exec php composer install --no-cache --ansi --no-interaction
endif

ifeq ($(filter tinker,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
tinker: ## php artisan tinker
	$(COMPOSE) exec php php artisan tinker
endif

ifeq ($(filter migrate,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
migrate: ## php artisan migrate
	$(COMPOSE) exec php php artisan migrate
endif

ifeq ($(filter php-artisan,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
php-artisan: ## php artisan commands. example: make php-artisan tinker | php artisan migrate | and others php artisan commands..
	$(COMPOSE) exec php php artisan $(ARGS)
endif

#============= NPM ===============#
ifeq ($(filter npm,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
npm: ## Examples: make npm install | make npm run build | make npm run dev | and others npm commands..
	$(COMPOSE) exec node npm $(ARGS)
endif

#============= Database ===============#
ifeq ($(filter db-import,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
db-import: ## Import database from file: make db-import filepath=../db.sql
	@test -n "$(filepath)" && test -r "$(filepath)" && test -s "$(filepath)" || { echo "Set filepath to a readable, non-empty SQL dump."; exit 1; }
	@$(COMPOSE) exec -T mysql sh -eu -c 'export MYSQL_PWD="$$MYSQL_PASSWORD"; exec mysql -u "$$MYSQL_USER" "$$MYSQL_DATABASE"' < "$(filepath)"
endif


#============= Portainer ===============#
ifeq ($(filter portainer-install,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))),)
portainer-install: ## Install portainer
	docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
endif




# Treat trailing words as arguments only for commands that accept them.
ARG_COMMANDS := up build restart stop connect connect-root logs down down-cont-vol down-cont-img down-all php-artisan npm
ifneq ($(filter $(COMMAND),$(ARG_COMMANDS)),)
ifneq ($(strip $(ARGS)),)
.PHONY: $(ARGS)
$(ARGS):;@:
endif
endif
.PHONY: init-dev init-prod up build restart hard-restart stop connect connect-root logs down down-cont-vol down-cont-img down-all ps config laravel-install composer-install tinker migrate php-artisan npm db-import portainer-install
