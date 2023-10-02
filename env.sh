#!/bin/bash -i

ROOT_DIR=$(readlink -f $(dirname $0))
PYTHON_VERSION=3.11
export MAMBA_ROOT_PREFIX=$ROOT_DIR/.mamba

function main () {
    local name=$1
    set -eh
    if [[ ! -d $MAMBA_ROOT_PREFIX ]]; then
        micromamba create -n $name python=$PYTHON_VERSION -c conda-forge
        eval "$(micromamba shell hook -s bash)"
        micromamba activate $name
        micromamba install poetry -c conda-forge
        if [[ -e pyproject.toml ]]; then
            poetry install
        fi
    else
        eval "$(micromamba shell hook -s bash)"
        micromamba activate $name
    fi
    eval "$(poetry completions bash)"
    set +e
}

unset GETOPT_COMPATIBLE
GETOPT_TEMP=$(getopt -n env.sh -s bash -o p: -l python: -- "$@")
if [[ $? != 0 ]]; then
    exit 1
fi
eval set -- "$GETOPT_TEMP"
while true; do
    case "$1" in
        -p | --python )
            python_version=$2
            shift 2
            ;;
        -- )
            shift
            break
            ;;
        * )
            echo env.sh: internal error 1>&2
            exit 2
            ;;
    esac
done

if [[ ! -z $python_version ]]; then
    PYTHON_VERSION=$python_version
fi
if [[ $# == 0 ]]; then
    echo env.sh: missing env name 1>&2
    exit 3
fi
cd $ROOT_DIR
main "$@"
