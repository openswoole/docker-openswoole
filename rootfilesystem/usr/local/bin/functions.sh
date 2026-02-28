#!/usr/bin/env bash
#
# Environment variables used during OpenSwoole installation:
#     * DEV_MODE
#     * OPENSWOOLE_SRC_DIR: Points to directory /usr/src/ext-openswoole.
#     * OPENSWOOLE_FUNCTIONS_LOADED: TRUE if this script has been loaded.
#     * OPENSWOOLE_VERSION: Could be one of following:
#         * master                                   # "master" is a branch name.
#         * v4.3.3                                   # "v4.3.3" is a tag.
#         * e52c4b78b4a016fffb049490555a8858ca16edb6 # a full Git commit number.
#

# Download an OpenSwoole package from Github.
#
# @param OpenSwoole package name.
# @param Version #.
function download()
{
    if [[ -z "${OPENSWOOLE_SRC_DIR}" ]] ; then
        echo "Error: environment variable OPENSWOOLE_SRC_DIR is empty or not yet set."
        exit 1
    fi

    project_name=$1
    if [[ "ext-openswoole" = "${project_name}" ]] ; then
        if [[ ! -d "$(dirname "${OPENSWOOLE_SRC_DIR}")" ]] ; then
            echo "Error: Parent folder \"$(dirname "${OPENSWOOLE_SRC_DIR}")\" does not exist."
            exit 1
        fi
        cd "$(dirname "${OPENSWOOLE_SRC_DIR}")"
    else
        if [[ ! -d "${OPENSWOOLE_SRC_DIR}" ]] ; then
            echo "Error: environment variable OPENSWOOLE_SRC_DIR does not point to a valid folder at \"${OPENSWOOLE_SRC_DIR}\"."
            exit 1
        fi
        cd "${OPENSWOOLE_SRC_DIR}"
    fi

    if [[ -z "$2" ]] ; then
        version=master
    else
        version=$2
    fi

    if [[ "${version}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(\-?[A-Za-z0-9]+)?$ ]] ; then
        downlaod_url="https://github.com/openswoole/${project_name}/archive/${version}.zip"
        unzipped_dir="${project_name}-${version#*v}"
    elif [[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+(\-?[A-Za-z0-9]+)?$ ]] ; then
        downlaod_url="https://github.com/openswoole/${project_name}/archive/v${version}.zip"
        unzipped_dir="${project_name}-${version}"
    else
        downlaod_url="https://github.com/openswoole/${project_name}/archive/${version}.zip"
        unzipped_dir="${project_name}-${version}"
    fi

    if [[ -f temp.zip ]] ; then
        rm -f temp.zip
    fi
    if [[ -d "${unzipped_dir}" ]] ; then
        rm -rf "${unzipped_dir}"
    fi
    if [[ -d "${project_name}" ]] ; then
        rm -rf "${project_name}"
    fi

    if ! curl -sfL "${downlaod_url}" -o temp.zip ; then
        echo Error: failed to download from URL "${downlaod_url}"
        exit 1
    fi
    unzip temp.zip
    if [[ ! -d "${unzipped_dir}" ]] ; then
        echo "Error: top directory in the zip file downloaded from URL '${downlaod_url}' is not '${unzipped_dir}'."
        exit 1
    fi
    mv "${unzipped_dir}" "${project_name}"
    rm -f temp.zip
    cd -
}

# Install an OpenSwoole package from source code.
#
# @param OpenSwoole package name.
# @param Version #.
# @param Rest parameters are the configure options.
function install()
{
    old_pwd="$(pwd)"

    download "$1" "$2"
    cd - # Last command in function download() is "cd -", so here we switch to the folder where the source code sits.
    cd "$1"
    phpize
    ./configure "${@:3}"
    make -j$(nproc)
    make install
    make clean

    cd "${old_pwd}"
}

function cleanupOpenswoole()
{
    if [[ "true" = "${DEV_MODE}" ]] ; then
        echo "OpenSwoole is installed for development purpose with source code included in folder \"${OPENSWOOLE_SRC_DIR}\"."
    else
        rm -rf "${OPENSWOOLE_SRC_DIR}"
    fi
}

function initOpenswooleDir()
{
    if [[ -d /usr/src ]] ; then
        OPENSWOOLE_SRC_DIR=/usr/src/ext-openswoole
    else
        if [[ $(pwd) == "/" ]] ; then
           OPENSWOOLE_SRC_DIR=/ext-openswoole
        else
           OPENSWOOLE_SRC_DIR="$(pwd)/ext-openswoole"
        fi
    fi

    export OPENSWOOLE_SRC_DIR="${OPENSWOOLE_SRC_DIR}"
}

initOpenswooleDir
OPENSWOOLE_FUNCTIONS_LOADED=true
