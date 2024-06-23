```
git clone https://github.com/suvarivaza/laravel-docker-traefik.git docker
cd docker
make init-dev
make up
```

```
make laravel-install
make npm-install
make npm-dev
```

For vite just add to vite.config.js:
```
server: {
            host: '0.0.0.0',
        },
```
