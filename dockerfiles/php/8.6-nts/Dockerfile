FROM php:8.6-cli

LABEL maintainer="Open Swoole Group <hello@openswoole.com>"

ENV COMPOSER_ALLOW_SUPERUSER=1

# The official PHP 8.6 images are thread safe (ZTS). OpenSwoole supports non thread safe (NTS) PHP,
# so PHP is rebuilt here with the same options, without --enable-zts.
RUN set -eux; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends $PHPIZE_DEPS libargon2-dev libcurl4-openssl-dev \
        libonig-dev libreadline-dev libsodium-dev libsqlite3-dev libssl-dev libxml2-dev zlib1g-dev; \
    docker-php-source extract; \
    cd /usr/src/php; \
    rm -rf /usr/local/lib/php /usr/local/include/php /usr/local/etc/php/conf.d/*; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    ./configure --build="$gnuArch" --sysconfdir=/usr/local/etc --with-config-file-path=/usr/local/etc/php \
        --with-config-file-scan-dir=/usr/local/etc/php/conf.d --enable-option-checking=fatal --with-mhash \
        --enable-mysqlnd --with-password-argon2 --with-sodium=shared --with-pdo-sqlite=/usr --with-sqlite3=/usr \
        --with-curl --with-iconv --with-openssl --with-readline --with-zlib --enable-phpdbg \
        --enable-phpdbg-readline --with-libdir="lib/$debMultiarch" --enable-embed; \
    make -j"$(nproc)"; \
    make install; \
    make clean; \
    cd /; \
    docker-php-source delete; \
    docker-php-ext-enable sodium; \
    php -r 'exit(PHP_ZTS ? 1 : 0);'

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
