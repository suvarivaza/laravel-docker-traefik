init-dev:
	cp .env.dev .env && touch ../.env

init-prod:
	cp .env.prod .env

up:
	docker compose up -d --build

build:
	docker compose build --no-cache

down:
	docker compose down

restart:
	make down && make up

cli:
	docker compose exec php bash

logs:
	docker compose logs -f --tail=20

delete-all:
	docker compose down -v --rmi all

laravel-install:
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
