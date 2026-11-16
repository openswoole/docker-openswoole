FROM php:8.6-rc-cli

LABEL maintainer="Open Swoole Group <hello@openswoole.com>"

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update -y && \
    apt-get install -y \
        procps \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        openssl \
        libssh-dev \
        libonig-dev \
        libcurl4-openssl-dev \
        libc-ares-dev \
        libpq-dev \
        linux-libc-dev \
        curl \
        wget \
        zip \
        unzip \
        git \
        vim && \
    docker-php-ext-install \
        gd \
        mbstring \
        pdo_mysql \
        mysqli \
        sockets \
        pcntl && \
    echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update --clean-backups && \
    apt-get install -y \
        gdb \
        strace \
        valgrind && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*
