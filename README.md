# Docker Image for OpenSwoole

[![Docker Pulls](https://img.shields.io/docker/pulls/openswoole/openswoole.svg)](https://hub.docker.com/r/openswoole/openswoole)
[![GitHub stars](https://img.shields.io/github/stars/openswoole/docker-openswoole)](https://github.com/openswoole/docker-openswoole/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/openswoole.svg?style=social&label=Follow%20%40OpenSwoole)](https://twitter.com/openswoole)

[![Versioned Images](https://github.com/openswoole/docker-openswoole/actions/workflows/build_versioned_images.yml/badge.svg)](https://github.com/openswoole/docker-openswoole/actions/workflows/build_versioned_images.yml)
[![Versioned Alpine Images](https://github.com/openswoole/docker-openswoole/actions/workflows/build_versioned_alpine_images.yml/badge.svg)](https://github.com/openswoole/docker-openswoole/actions/workflows/build_versioned_alpine_images.yml)
[![Latest Images](https://github.com/openswoole/docker-openswoole/actions/workflows/build_latest_images.yml/badge.svg)](https://github.com/openswoole/docker-openswoole/actions/workflows/build_latest_images.yml)
[![Latest Alpine Images](https://github.com/openswoole/docker-openswoole/actions/workflows/build_latest_alpine_images.yml/badge.svg)](https://github.com/openswoole/docker-openswoole/actions/workflows/build_latest_alpine_images.yml)

This image is built for general-purpose. We have different examples included in this Git repository to help developers
to get familiar with the image and _OpenSwoole_.

You can get the image from [Docker Hub](https://hub.docker.com/r/openswoole/openswoole).

> Latest released version `:25.2.0` for `PHP8.2` `PHP8.3` `PHP8.4`

# How to Use This Image

The `openswoole/openswoole` image is built using [the official PHP image](https://hub.docker.com/_/php) as base image, with a few changes.

For basic usage, please check the description section of [the official PHP image](https://hub.docker.com/_/php).

## How to Install More PHP Extensions

Same as in the official PHP image, most PHP extensions can be installed/configured using built-in helper scripts `docker-php-ext-configure`, `docker-php-ext-install`, `docker-php-ext-enable`, and `docker-php-source`. Here are some examples.

```Dockerfile
# To install the MySQL extensions.
FROM openswoole/openswoole:25.2-php8.4-alpine

RUN docker-php-ext-install mysqli pdo_mysql
```

```Dockerfile
# To install the Redis extension.
FROM openswoole/openswoole:25.2-php8.4-alpine

RUN set -ex \
    && pecl update-channels \
    && pecl install redis-stable \
    && docker-php-ext-enable redis
```

## More Examples

**Following examples are for non-Alpine images only**. We don't have examples included for the Alpine images.

You can use the image to serve an HTTP/WebSocket server, or run some one-off command with it. e.g.,

```bash
docker run --rm openswoole/openswoole "php -m"
docker run --rm openswoole/openswoole "php --ri openswoole"
docker run --rm openswoole/openswoole "composer --version"
```

# Image Variants

The `openswoole/openswoole` images come in three flavors, each designed for a specific use case. **In production environment, we suggest using the Alpine images.**

### 1. `latest`, `<openswoole-version>`, and `<openswoole-version>-php<php-version>`

* `openswoole/openswoole:latest`
* `openswoole/openswoole:25.2`
* `openswoole/openswoole:25.2-php8.4`
* `openswoole/openswoole:25.2.0-php8.4`

This variant is based on the _php:cli_ images, with a few changes. It uses _Supervisord_ to manage booting processes, and has _Composer_ preinstalled.

### 2. `latest-alpine`, `<openswoole-version>-alpine`, and `<openswoole-version>-php<php-version>-alpine`

* `openswoole/openswoole:latest-alpine`
* `openswoole/openswoole:25.2-alpine`
* `openswoole/openswoole:25.2-php8.4-alpine`
* `openswoole/openswoole:25.2.0-php8.4-alpine`

You can use this variant in the same way as using the _php:alpine_ image, except that we changed the default working directory to _/var/www_.
Also, we have _Composer_ preinstalled in the image.

# Build Images Manually

The Docker images are built and pushed out automatically through Travis. If you want to build some image manually, please
follow these three steps.

**1**. Install Composer packages. If you have command "composer" installed already, just run `composer update -n`.

**2**. Use commands like following to create dockerfiles:

```bash
./bin/generate-dockerfiles.php latest # Generate dockerfiles to build images from the master branch of Open Swoole.
./bin/generate-dockerfiles.php 25.2.0  # Generate dockerfiles to build images for Open Swoole 25.2.0.
```

**3**. Build Docker images with commands like:

```bash
docker build -t openswoole/openswoole                     -f dockerfiles/latest/php8.4/cli/Dockerfile   .
docker build -t openswoole/openswoole:25.2.0-php8.4        -f dockerfiles/25.2.0/php8.4/cli/Dockerfile    .
docker build -t openswoole/openswoole:25.2.0-php8.4-alpine -f dockerfiles/25.2.0/php8.4/alpine/Dockerfile .
```
