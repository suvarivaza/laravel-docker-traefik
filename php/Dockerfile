ARG PHP_VERSION=8.2
FROM serversideup/php:${PHP_VERSION}-fpm-nginx AS base
USER root
RUN install-php-extensions intl gd exif bcmath pdo_mysql redis
WORKDIR /var/www/html
USER www-data

FROM base AS development
USER root
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN docker-php-serversideup-set-id www-data ${USER_ID}:${GROUP_ID} && \
    docker-php-serversideup-set-file-permissions --owner ${USER_ID}:${GROUP_ID} --service nginx
USER www-data

# Application files are mounted through APP_PATH in both environments.
FROM base AS production
