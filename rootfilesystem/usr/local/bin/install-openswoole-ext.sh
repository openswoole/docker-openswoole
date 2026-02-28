#!/usr/bin/env bash
# How to run the script?
#     install-openswoole-ext.sh postgresql master                                   # "master" is a branch name.
#
# NOTE：You can call bash function cleanupOpenswoole() to remove the source code directory manually after the installation.

set -ex

[[ -z "${OPENSWOOLE_FUNCTIONS_LOADED}" ]] && . functions.sh

if ! php --ri openswoole ; then
    echo "Error: PHP exension \"openswoole\" is not installed or enabled."
    exit 1
fi

if [[ ! -d "${OPENSWOOLE_SRC_DIR}" ]] ; then
    download ext-openswoole "${OPENSWOOLE_VERSION}"
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
