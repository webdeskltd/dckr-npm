#!/bin/bash

DIR=/Users/kallisto/Projects/tubecj/tcjtowerfront

docker run -i -t --rm -v ${DIR}:/src webdeskltd/npm:latest
