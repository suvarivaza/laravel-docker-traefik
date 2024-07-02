include .env

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

php-bash-root: ## Connect to php bash
	docker compose exec -u 0 php bash

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


#============= Laravel ===============#

laravel-install: ## Install Laravel
	docker compose exec php composer create-project laravel/laravel example-app \
	&& mv -f ../example-app/* ../ && mv -f ../example-app/.* ../ && rm -rf ../example-app

composer-install: ## composer install
	docker compose exec -u 0 php composer install --no-cache --ansi --no-interaction

npm-install: ## npm install
	 docker compose exec node npm install

npm-build: ## npm run build
	 docker compose exec node npm run build

npm-dev: ## npm run dev
	 docker compose exec node npm run dev

tinker: ## php artisan tinker
	docker compose exec php php artisan tinker

migrate: ## php artisan migrate
	docker compose exec php php artisan migrate


#============= Database ===============#

db-import: ## Import database from file: make db-import filepath=../db.sql
	sudo docker exec -i $(COMPOSE_PROJECT_NAME)-mysql-1 mysql -u $(DB_USERNAME) -p$(DB_PASSWORD) $(DB_DATABASE) < $(filepath)

#============= Portainer ===============#

portainer-install: ## Install portainer
	docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce


#============= Help ===============#
.PHONY: help
help:
	@echo ======= Help =======
	@echo You can pass the service name like this: make up name=php
	@egrep -h '^[^[:blank:]].*\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
