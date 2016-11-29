#!/bin/bash

# docker run --privileged -d -p 8080:8000 -v /sys/fs/cgroup:/sys/fs/cgroup:ro webdeskltd/npm
# docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro webdeskltd/npm
# docker run --privileged -d -p 8080:8080 -p 9000:9000 -v /sys/fs/cgroup:/sys/fs/cgroup:ro webdeskltd/npm
docker run -d webdeskltd/npm
