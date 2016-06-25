#!/bin/bash

source ./properties.sh .

echo "Starting new Docker image($registry/$maintainer/$imagename)"
docker run --name=$imagename \
            -e ENV_BASE_NGINX_CONFIG=$ENV_BASE_NGINX_CONFIG \
            -e ENV_DERIVED_NGINX_CONFIG=$ENV_DERIVED_NGINX_CONFIG \
            -e ENV_DEFAULT_ROOT_VOLUME=$ENV_DEFAULT_ROOT_VOLUME \
            -v $EXT_MOUNTED_VOLUME:$INT_MOUNTED_VOLUME \
            -p 82:80 \
            -p 444:443 \
            -d $maintainer/$imagename 

exit 0
