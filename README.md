# Docker Image for OpenSwoole

[![Tests](https://github.com/openswoole/docker-swoole/workflows/Tests/badge.svg)](https://github.com/openswoole/docker-swoole/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/openswoole/swoole.svg)](https://hub.docker.com/r/openswoole/swoole)
[![License](https://img.shields.io/badge/license-apache2-blue.svg)](https://github.com/openswoole/docker-swoole/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/openswoole/docker-swoole)](https://github.com/openswoole/docker-swoole/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/openswoole.svg?style=social&label=Follow%20%40OpenSwoole)](https://twitter.com/openswoole)

[![Versioned Images](https://github.com/openswoole/docker-swoole/actions/workflows/build_versioned_images.yml/badge.svg)](https://github.com/openswoole/docker-swoole/actions/workflows/build_versioned_images.yml)
[![Versioned Alpine Images](https://github.com/openswoole/docker-swoole/actions/workflows/build_versioned_alpine_images.yml/badge.svg)](https://github.com/openswoole/docker-swoole/actions/workflows/build_versioned_alpine_images.yml)
[![Latest Images](https://github.com/openswoole/docker-swoole/actions/workflows/build_latest_images.yml/badge.svg)](https://github.com/openswoole/docker-swoole/actions/workflows/build_latest_images.yml)
[![Latest Alpine Images](https://github.com/openswoole/docker-swoole/actions/workflows/build_latest_alpine_images.yml/badge.svg)](https://github.com/openswoole/docker-swoole/actions/workflows/build_latest_alpine_images.yml)

This image is built for general-purpose. We have different examples included in this Git repository to help developers
to get familiar with the image and _OpenSwoole_.

You can get the image from [Docker Hub](https://hub.docker.com/r/openswoole/swoole).

> Latest released version `:4.11.0` with PHP 8.1

Table of Contents
=================

   * [Feature List](#feature-list)
   * [How to Use This Image](#how-to-use-this-image)
      * [How to Install More PHP Extensions](#how-to-install-more-php-extensions)
      * [More Examples](#more-examples)
   * [Image Variants](#image-variants)
   * [Supported Tags and Respective Dockerfile Links](#supported-tags-and-respective-dockerfile-links)
      * [Versioned images](#versioned-images-based-on-stable-releases-of-swoole)
         * [OpenSwoole 4.7](#swoole-47)
      * [Nightly images](#nightly-images-built-daily-using-the-master-branch-of-swoole-src)
   * [Build Images Manually](#build-images-manually)
   * [Credits](#credits)

# Feature List

* Built-in scripts to manage _OpenSwoole_ extensions and _Supervisord_ programs.
* Easy to manage booting scripts in Docker.
* Allow running PHP scripts and other commands directly in different environments (including ECS).
* Use one root filesystem for simplicity (one Docker `COPY` command only in dockerfiles).
* _Composer v2_ for OpenSwoole 4.7.2 and after).
* Built for different architectures.
* Support auto-reloading for local development.
* Support code debugging for local development.

# How to Use This Image

The `openswoole/swoole` image is built using [the official PHP image](https://hub.docker.com/_/php) as base image, with a few changes.
For basic usage, please check the description section of [the official PHP image](https://hub.docker.com/_/php).

## How to Install More PHP Extensions

Same as in the official PHP image, most PHP extensions can be installed/configured using built-in helper scripts `docker-php-ext-configure`, `docker-php-ext-install`, `docker-php-ext-enable`, and `docker-php-source`. Here are some examples.

```Dockerfile
# To install the MySQL extensions.
FROM openswoole/swoole:4.11-php7.4-alpine

RUN docker-php-ext-install mysqli pdo_mysql
```

```Dockerfile
# To install the Redis extension.
FROM openswoole/swoole:4.10-php7.4-alpine

RUN set -ex \
    && pecl update-channels \
    && pecl install redis-stable \
    && docker-php-ext-enable redis
```

```Dockerfile
# To install the Couchbase extension.
FROM openswoole/swoole:4.10-php7.4-alpine

RUN set -ex \
    && apk update \
    && apk add --no-cache libcouchbase=2.10.6-r0 \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS libcouchbase-dev=2.10.6-r0 zlib-dev \
    && pecl update-channels \
    && pecl install couchbase-2.6.2 \
    && docker-php-ext-enable couchbase \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/src/php.tar.xz*
```

## More Examples

**Following examples are for non-Alpine images only**. We don't have examples included for the Alpine images.

You can use the image to serve an HTTP/WebSocket server, or run some one-off command with it. e.g.,

```bash
docker run --rm openswoole/swoole "php -m"
docker run --rm openswoole/swoole "php --ri openswoole"
docker run --rm openswoole/swoole "composer --version"
```

We have various examples included under folder "_examples/_" to help developers better use the image. These examples are
numerically ordered. Each example has a _docker-compose.yml_ file included, along with some other files. To run an
example, please start Docker containers using the _docker-compose.yml_ file included, then check HTTP output from URL
http://127.0.0.1 unless otherwise noted. You may use the following commands to start/stop/restart Docker containers:

```bash
./bin/example.sh start   00 # To start container(s) of the first example.
./bin/example.sh stop    00 # To stop container(s) of the first example.
./bin/example.sh restart 00 # To restart container(s) of the first example.
```

To run another example, just replace the last command line parameter _00_ with an example number (e.g., _05_).

Here is a list of the examples under folder "_examples/_":

* Basic examples:
    * **00-autoload**: Restart the Swoole web server automatically if file changes detected under web root.
    * **01-basic**: print out "Hello, World!" using Swoole as backend HTTP server.
    * **02-www**: to use some customized PHP script(s) in the Docker image built.
    * **03-nginx**: to use Swoole behind an Nginx server.
    * **04-entrypoint**: to use a self-defined entrypoint script in the Docker image built.
    * **05-boot**: to update content in the Docker container through a booting script.
    * **06-update-token**: to show how to update server configurations with built-in script _update-token.sh_.
    * **07-disable-default-server**: Please check the [docker-compose.yml](https://github.com/openswoole/docker-swoole/blob/master/examples/07-disable-default-server/docker-compose.yml) file included to see show how to disable the default web server created with _Swoole_.
* Manage PHP extensions and configurations:
    * **10-install-php-extension**: how to install/enable PHP extensions.
    * **11-customize-extension-options**: how to overwrite/customize PHP extension options.
    * **12-php.ini**: how to overwrite/customize PHP options.
    * **13-install-swoole-extension**: Please check the [README](https://github.com/openswoole/docker-swoole/tree/master/examples/13-install-swoole-extension) file included to see how to install Swoole extensions like [postgresql](https://github.com/openswoole/ext-postgresql).
* Manage Supervisord programs:
    * **20-supervisord-services**: to show how to run Supervisord program(s) in Docker.
    * **21-supervisord-tasks**: to show how to run Supervisord program(s) when launching a one-off command with Docker. Please check the [README](https://github.com/openswoole/docker-swoole/tree/master/examples/21-supervisord-tasks) file included to see how to run the example.
    * **22-supervisord-enable-program**: to show how to enable program(s) in Supervisord program.
    * **23-supervisord-disable-program**: to show how to disable Supervisord program(s).
* Debugging:
    * **30-debug-with-gdb**: Please check the [README](https://github.com/openswoole/docker-swoole/tree/master/examples/30-debug-with-gdb) file included to see how to debug your PHP code with _gdb_.
    * **31-debug-with-valgrind**: Please check the [README](https://github.com/openswoole/docker-swoole/tree/master/examples/31-debug-with-valgrind) file included to see how to debug your PHP code with _Valgrind_.
    * **32-debug-with-strace**: Please check the [README](https://github.com/openswoole/docker-swoole/tree/master/examples/32-debug-with-strace) file included to see how to debug your PHP code with _strace_.

# Image Variants

The `openswoole/swoole` images come in three flavors, each designed for a specific use case. **In production environment, we suggest using the Alpine images.**

### 1. `latest`, `<swoole-version>`, and `<swoole-version>-php<php-version>`

* `openswoole/swoole:latest`
* `openswoole/swoole:4.11`
* `openswoole/swoole:4.11-php8.0`
* `openswoole/swoole:4.11.0-php8.0`

This variant is based on the _php:cli_ images, with a few changes. It uses _Supervisord_ to manage booting processes, and has _Composer_ preinstalled.

### 2. `latest-dev`, `<swoole-version>-dev`, and `<swoole-version>-php<php-version>-dev`

* `openswoole/swoole:latest-dev`
* `openswoole/swoole:4.11-dev`
* `openswoole/swoole:4.11-php8.0-dev`
* `openswoole/swoole:4.11.0-php8.0-dev`

This variant is very similar to the previous one, but it has extra tools added for testing, debugging, and monitoring purpose,
including [gdb](https://www.gnu.org/s/gdb), git, lsof, [strace](https://strace.io), [tcpdump](https://www.tcpdump.org), [Valgrind](http://www.valgrind.org), and vim.

### 3. `latest-alpine`, `<swoole-version>-alpine`, and `<swoole-version>-php<php-version>-alpine`

* `openswoole/swoole:latest-alpine`
* `openswoole/swoole:4.11-alpine`
* `openswoole/swoole:4.11-php8.0-alpine`
* `openswoole/swoole:4.11.0-php8.0-alpine`

You can use this variant in the same way as using the _php:alpine_ image, except that we changed the default working directory to _/var/www_.
Also, we have _Composer_ preinstalled in the image.

Note: We don't have development tools built in for Alpine images. There is no Docker images like `openswoole/swoole:4.9.1-php8.1-alpine-dev`.

# Supported Tags and Respective `Dockerfile` Links

## Versioned images (based on stable releases of Swoole)

### Open Swoole 4.10

| PHP Versions | Default Images | Dev Images | Alpine Images |
|-|-|-|-|
| PHP 8.1 | [4.8.1-php8.1, 4.8-php8.1<br />4.8, latest](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.1/cli/Dockerfile) | [4.8.1-php8.1-dev, 4.8-php8.1-dev<br />4.8-dev, latest-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.1/cli/Dockerfile) | [4.8.1-php8.1-alpine, 4.8-php8.1-alpine<br />4.8-alpine, latest-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.1/alpine/Dockerfile) |
| PHP 8.0 | [4.8.1-php8.0, 4.8-php8.0<br />4.8, latest](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.0/cli/Dockerfile) | [4.8.1-php8.0-dev, 4.8-php8.0-dev<br />4.8-dev, latest-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.0/cli/Dockerfile) | [4.8.1-php8.0-alpine, 4.8-php8.0-alpine<br />4.8-alpine, latest-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php8.0/alpine/Dockerfile) |
| PHP 7.4 | [4.8.1-php7.4, 4.8-php7.4](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.4/cli/Dockerfile) | [4.8.1-php7.4-dev, 4.8-php7.4-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.4/cli/Dockerfile) | [4.8.1-php7.4-alpine, 4.8-php7.4-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.4/alpine/Dockerfile) |
| PHP 7.3 | [4.8.1-php7.3, 4.8-php7.3](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.3/cli/Dockerfile) | [4.8.1-php7.3-dev, 4.8-php7.3-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.3/cli/Dockerfile) | [4.8.1-php7.3-alpine, 4.8-php7.3-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.3/alpine/Dockerfile) |
| PHP 7.2 | [4.8.1-php7.2, 4.8-php7.2](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.2/cli/Dockerfile) | [4.8.1-php7.2-dev, 4.8-php7.2-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.2/cli/Dockerfile) | [4.8.1-php7.2-alpine, 4.8-php7.2-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/4.8.1/php7.2/alpine/Dockerfile) |


## Nightly images (built daily using the master branch of [swoole-src](https://github.com/openswoole/swoole-src))

| PHP Versions | Default Images | Dev Images | Alpine Images |
|-|-|-|-|
| PHP 8.1 | [php8.1](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.1/cli/Dockerfile) | [php8.1-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.1/cli/Dockerfile) | [php8.1-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.1/alpine/Dockerfile) |
| PHP 8.0 | [php8.0](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.0/cli/Dockerfile) | [php8.0-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.0/cli/Dockerfile) | [php8.0-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php8.0/alpine/Dockerfile) |
| PHP 7.4 | [php7.4](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.4/cli/Dockerfile) | [php7.4-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.4/cli/Dockerfile) | [php7.4-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.4/alpine/Dockerfile) |
| PHP 7.3 | [php7.3](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.3/cli/Dockerfile) | [php7.3-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.3/cli/Dockerfile) | [php7.3-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.3/alpine/Dockerfile) |
| PHP 7.2 | [php7.2](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.2/cli/Dockerfile) | [php7.2-dev](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.2/cli/Dockerfile) | [php7.2-alpine](https://github.com/openswoole/docker-swoole/blob/master/dockerfiles/latest/php7.2/alpine/Dockerfile) |

# Build Images Manually

The Docker images are built and pushed out automatically through Travis. If you want to build some image manually, please
follow these three steps.

**1**. Install Composer packages. If you have command "composer" installed already, just run `composer update -n`.

**2**. Use commands like following to create dockerfiles:

```bash
./bin/generate-dockerfiles.php latest # Generate dockerfiles to build images from the master branch of Open Swoole.
./bin/generate-dockerfiles.php 4.10.0  # Generate dockerfiles to build images for Open Swoole 4.10.0.
```

**3**. Build Docker images with commands like:

```bash
docker build -t openswoole/swoole                     -f dockerfiles/latest/php8.0/cli/Dockerfile   .
docker build -t openswoole/swoole:4.11.0-php8.0        -f dockerfiles/4.11.0/php8.0/cli/Dockerfile    .
docker build -t openswoole/swoole:4.11.0-php8.0-alpine -f dockerfiles/4.11.0/php8.0/alpine/Dockerfile .
```

To build development images (where extra tools are included), add an argument _DEV_MODE_:

```bash
docker build --build-arg DEV_MODE=true -t openswoole/swoole:latest-dev       -f dockerfiles/latest/php8.0/cli/Dockerfile .
docker build --build-arg DEV_MODE=true -t openswoole/swoole:4.11.0-php8.0-dev -f dockerfiles/4.11.0/php8.0/cli/Dockerfile  .
```

# Credits

Orignal implementation was done by [Demin](https://github.com/deminy) at [Glu Mobile](https://glu.com).
