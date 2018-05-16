#!/bin/bash

# Make sure we're in the project root folder.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Copy over latest changes to the app
docker cp ./frontend/ami-code/app ami-docker_frontend_1:/data/