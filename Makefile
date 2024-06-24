init-dev:
	cp .env.dev .env && touch ../.env

init-prod:
	cp .env.prod .env

up: ## Start containers.
	docker compose up -d --build $(name)

build: ## Build containers
	docker compose build --no-cache $(name)

restart: ## Restart ALL containers
	make down && make up

php-bash: ## Connect to php bash
	docker compose exec php bash

logs: ## Logs containers
	docker compose logs -f --tail=20 $(name)

down: ## Delete containers
	docker compose down $(name)

down-cv: ## Delete containers and volumes
	docker compose down -v $(name)

down-ci: ## Delete containers and images
	docker compose down --rmi all $(name)

down-all: ## WARNING! Delete ALL! containers / networks / images / volumes
	docker compose down -v --rmi all $(name)

laravel-install: ## Install laravel
	docker compose exec php composer create-project laravel/laravel example-app \
	&& mv -f ../example-app/* ../ && mv -f ../example-app/.* ../ && rm -rf ../example-app

laravel-upl:
	make restart

npm-install:
	 docker compose exec node npm install

npm-build:
	 docker compose exec node npm run build

npm-dev:
	 docker compose exec node npm run dev

tinker:
	docker compose exec php php artisan tinker


#============= Help ===============#
.PHONY: help
help:
	@echo ======= Help =======
	@echo You can pass the service name like this: make up name=php
	@egrep -h '^[^[:blank:]].*\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
