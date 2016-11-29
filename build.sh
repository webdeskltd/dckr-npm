#!/bin/bash

# OsType="$(uname -s 2>&1 | tr '[:upper:]' '[:lower:]')"; if [ "${OsType}" == "darwin" ]; then docker-machine start default; eval "$(docker-machine env default)"; fi

docker build --rm -t webdeskltd/npm .

# if [ "${OsType}" == "darwin" ]; then docker-machine stop default; fi
