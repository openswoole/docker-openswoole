# Docker Image for OpenSwoole

[![Docker Pulls](https://img.shields.io/docker/pulls/openswoole/openswoole.svg)](https://hub.docker.com/r/openswoole/openswoole)
[![License](https://img.shields.io/badge/license-apache2-blue.svg)](https://github.com/openswoole/docker-openswoole/blob/master/LICENSE)

> Latest released version `26.2.0` for PHP 8.3 / 8.4 / 8.5

## Image Variants

**Alpine (recommended for production):**

```
openswoole/openswoole:26.2.0-php8.3-alpine
openswoole/openswoole:latest-alpine
```

**CLI (Debian-based, includes Supervisord):**

```
openswoole/openswoole:26.2.0-php8.3
openswoole/openswoole:latest
```

**Dev (CLI + gdb, strace, valgrind, xdebug):**

```
openswoole/openswoole:26.2.0-php8.3-dev
openswoole/openswoole:latest-dev
```

All images include Composer v2 and are built for multiple architectures (amd64, arm/v6, arm/v7, arm64/v8, ppc64le).

OpenSwoole is compiled with: `--enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-hook-curl --enable-io-uring --with-postgres`

## Installing Additional PHP Extensions

```Dockerfile
FROM openswoole/openswoole:26.2.0-php8.3-alpine

RUN docker-php-ext-install mysqli pdo_mysql
```

```Dockerfile
FROM openswoole/openswoole:26.2.0-php8.3-alpine

RUN pecl install redis-stable && docker-php-ext-enable redis
```

## Build Images Manually

```bash
docker build -t openswoole/openswoole:26.2.0-php8.3        -f dockerfiles/26.2.0/php8.3/cli/Dockerfile    .
docker build -t openswoole/openswoole:26.2.0-php8.3-alpine -f dockerfiles/26.2.0/php8.3/alpine/Dockerfile .
```

Dev images:

```bash
docker build --build-arg DEV_MODE=true -t openswoole/openswoole:26.2.0-php8.3-dev -f dockerfiles/26.2.0/php8.3/cli/Dockerfile .
```
