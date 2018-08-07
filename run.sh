#!/bin/bash

DIR=`pwd`

docker run -i -t --rm -v ${DIR}:/src webdeskltd/npm:latest
