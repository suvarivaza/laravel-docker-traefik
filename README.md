This is docker environment for Laravel and other PHP applications!

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

### Start dev
```
make init-dev
make up
```

#### Laravel commands:
```
make laravel-install
make npm-install
make npm-dev
make npm-build
make tinker
```

>The app will be at: http://localhost/
>Phpmyadmin at: http://localhost:8081/


### Production
Do not forgot ser .env variables:
> TRAEFIK_APP_URL=your-site.com
> TRAEFIK_EMAIL=your@email.com

Then:
```
make init-prod
make up
```


### Vite
For Vite just add to vite.config.js:
```
server: {
            host: '0.0.0.0',
        },
```