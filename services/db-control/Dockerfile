FROM php:7.2-fpm

WORKDIR '/db'

# Hack to make instalation for psql work on the slim version of debian
RUN mkdir /usr/share/man/man1 && mkdir /usr/share/man/man7


RUN apt-get update && \
    apt-get install -y git libpq-dev libzip-dev zlib1g-dev postgresql-client && \
    docker-php-ext-install \
        zip \
        pdo \
        pdo_pgsql

COPY "./install_composer.sh" "install_composer.sh"

RUN bash install_composer.sh

RUN rm install_composer.sh
