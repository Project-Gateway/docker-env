FROM php:7.2-fpm

WORKDIR '/var/www/api'

RUN apt-get update && \
    apt-get install -y git libpq-dev libzip-dev zlib1g-dev --no-install-recommends && \
    docker-php-ext-install \
        zip \
        pdo \
        pdo_pgsql

COPY "./install_composer.sh" "install_composer.sh"

RUN bash install_composer.sh

RUN rm install_composer.sh

RUN composer global require hirak/prestissimo
