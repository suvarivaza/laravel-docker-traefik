This is docker compose environment for Laravel and other PHP applications!

- Ready for development and production!
- Easy to start!
- Free Let's Encrypt SSL certificates!

Services:
- traefik https://github.com/traefik/traefik
- php https://github.com/serversideup/docker-php
- mysql 
- phpmyadmin 
- redis

### Install
```
git clone https://github.com/suvarivaza/laravel-docker-traefik.git docker
cd docker
```

### Help
```
make help
```

### Start DEV

```
make init-dev
(set .env variables)
make up
```
Do not forget set .env variables after command: make init-dev!

> - The app will be: http://localhost:81/
> - Phpmyadmin: http://localhost:8080/




### Production

```
make init-prod
(set .env variables)
make up
```
Do not forget set .env variables after command: make init-prod!


### Main commands:
```
make up
make build
make restart
make stop
make down
make logs
```

Specific service:
```
make up php
make build php
make restart php
make stop php
make down php
make logs php
make connect php
```

#### Laravel commands:
```
make laravel-install
make composer-install
make tinker
make migrate
make php-artisan tinker | php artisan migrate | and others php artisan commands ...
```

#### NPM commands:
```
make npm install 
make npm run build 
make npm run dev
..and others npm commands..
```



### Additionally

```
make db-import filepath=path/db.sql
make portainer-install
```


#### Laravel Vite configuration
For Laravel Vite support just add to vite.config.js:
```
server: {
            host: '0.0.0.0',
        },
```

### Configuration and project location

Run Make from this directory, or use `make -C /path/to/docker-laravel`.
`init-dev` and `init-prod` never overwrite an existing `.env`.
Compose reads Docker's `.env`; the application's `.env` is not loaded by Make.
Set `DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE`, and `MYSQL_ROOT_PASSWORD`
in Docker's `.env`, and use matching credentials in Laravel's `.env`:
`DB_HOST=mysql`, `DB_PORT=3306`, `REDIS_HOST=redis`, `REDIS_PORT=6379`.
Replace the example passwords before starting. Changing them does not update
users in an existing MySQL volume.

`APP_PATH` is relative to this Docker directory, or an absolute path:

| Layout | APP_PATH |
| --- | --- |
| Docker inside the application | `..` |
| Docker next to the application directory | `../src` |
| Application elsewhere | `/srv/my-project` |

Paths containing spaces are supported. Application files are bind-mounted in
both dev and prod; the image itself does not contain the application.
Laravel is served from `/var/www/html/public`.
For Linux development, set `USER_ID` and `GROUP_ID` to `id -u` and `id -g`.
The dev image adjusts www-data accordingly; production uses the image's default user.

MySQL and Redis ports are bound to localhost in dev and are not published in prod.
Use `MYSQL_PORT` to change the host MySQL port; Laravel still uses port 3306.
phpMyAdmin requires the `tools` profile (enabled in `.env.dev`) and listens only
on localhost. In production, enable it explicitly with
`docker compose --env-file .env --profile tools up -d phpmyadmin`
and access it through an SSH tunnel. Log in with your database credentials.

Production requires `TRAEFIK_APP_URL` (a hostname without a scheme) and
`TRAEFIK_EMAIL`. Point DNS at the server and allow incoming ports 80 and 443.
HTTP redirects to HTTPS; Traefik obtains a certificate automatically.

Arguments can also be passed explicitly, for example:
`make npm ARGS="run build"` or `make php-artisan ARGS="queue:work --once"`.
Database import uses `make db-import filepath="../backup.sql"`, checks the file,
and imports into the existing database without an implicit DROP DATABASE.
The SQL dump itself may replace data; import is not automatically rolled back.
