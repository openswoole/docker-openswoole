#!/usr/bin/env bash
# This script is used to install OpenSwoole in the Docker image.
#
# How to use this script?
#     ./install-openswoole.sh [OPENSWOOLE_VERSION] [OpenSwoole installation options]
# For example,
#     ./install-openswoole.sh
#     ./install-openswoole.sh master
#     ./install-openswoole.sh 26.2.0 --enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-hook-curl
#
# The first parameter (OPENSWOOLE_VERSION) should be a branch name, a tag or a Git commit number. For example,
#     master                                   # To install OpenSwoole with latest code from branch "master".
#     b8a876a4b3f285c9682dabd80ae1aa15932050f9 # To install OpenSwoole with code from a Git commit.
#     26.2.0                                   # To install OpenSwoole 26.2.0.
#
# You can specify other predefined variables if needed. For example, on macOS Mojave you may need to specify LDFLAGS,
# CFLAGS and CPPFLAGS like following:
#
#     LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/lib -L/usr/local/opt/expat/lib"               \
#     CFLAGS="-I/usr/local/opt/openssl/include/ -I/usr/local/include -I/usr/local/opt/expat/include"   \
#     CPPFLAGS="-I/usr/local/opt/openssl/include/ -I/usr/local/include -I/usr/local/opt/expat/include" \
#     ./install-openswoole.sh 26.2.0 --enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-hook-curl
#
# Before using this script, you should have PHP extension sockets installed, and have packages like openssl installed
# already.

set -ex

[[ -z "${OPENSWOOLE_FUNCTIONS_LOADED}" ]] && . functions.sh

if [[ ! -z ${1} ]] ; then
    OPENSWOOLE_VERSION=$1
    shift 1 # Remove OpenSwoole version # out from command line arguments.
else
    OPENSWOOLE_VERSION=master
fi
export OPENSWOOLE_VERSION=$OPENSWOOLE_VERSION

# Get PHP extension sockets installed if needed.
if ! php -m | grep -q sockets ; then
    if hash docker-php-ext-install 2>/dev/null ; then
        docker-php-ext-install sockets
    else
        echo Error: PHP extension sockets not installed. Please have it installed first.
        exit 1
    fi
fi

if [[ "true" = "${DEV_MODE}" ]] ; then
    apt-get install -y gdb git lsof strace tcpdump valgrind vim --no-install-recommends
    pecl install xdebug && docker-php-ext-enable xdebug
    DEV_OPTIONS="--enable-debug --enable-debug-log --enable-trace-log"
else
    DEV_OPTIONS=""
fi
install ext-openswoole "${OPENSWOOLE_VERSION}" "$@" ${DEV_OPTIONS}
if hash docker-php-ext-enable 2>/dev/null ; then
    docker-php-ext-enable --ini-name zzz-docker-php-ext-openswoole.ini openswoole
else
    echo NOTICE: PHP extension openswoole is not enabled. Please have it enabled first.
fi

cleanupOpenswoole
