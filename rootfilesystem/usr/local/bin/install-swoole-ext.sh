#!/usr/bin/env bash
# How to run the script?
#     install-swoole-ext.sh postgresql master                                   # "master" is a branch name.
#
# NOTE：You can call bash function cleanupSwoole() to remove the source code directory manually after the installation.

set -ex

[[ -z "${SWOOLE_FUNCTIONS_LOADED}" ]] && . functions.sh

if ! php --ri openswoole ; then
    echo "Error: PHP exension \"openswoole\" is not installed or enabled."
    exit 1
fi

if [[ ! -d "${SWOOLE_SRC_DIR}" ]] ; then
    download swoole-src "${SWOOLE_VERSION}"
fi

case "${1}" in
    "postgresql")
        if ! dpkg -s libpq-dev >/dev/null 2>&1 ; then
            apt-get update
            apt-get install -y libpq-dev --no-install-recommends
            rm -r /var/lib/apt/lists/*
        fi
        ;;
    *)
        ;;
esac

install ext-"$1" $2 "${@:3}"
