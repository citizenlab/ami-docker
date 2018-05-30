#!/bin/bash

echo "Installing the Access My Info development environment."
echo "This may take several minutes."

# Check to see if Docker is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: Docker is not installed. Please install Docker and re-run this script.' >&2
  exit 1
fi

# Make sure we're in the project root folder.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Get the code for the frontend
git clone https://github.com/citizenlab/ami-frontend frontend/ami-code
cd frontend/ami-code

# Get the code for the community tools
cd $DIR
git clone https://github.com/citizenlab/ami-community community/ami-code
cd community/ami-code
mkdir jurisdiction_events

cd $DIR
# Set up the frontend config
cp ./frontend/ami-code/config/local.json.default ./frontend/ami-code/config/local.json
cp ./frontend/ami-code/config/dev.json.default ./frontend/ami-code/config/dev.json

# Set up community config
cp ./community/ami-code/conf/db.conf.js.default ./community/ami-code/conf/db.conf.js
cp ./community/ami-code/conf/policy.conf.js.default ./community/ami-code/conf/policy.conf.js
cp ./community/ami-code/conf/sendgrid.conf.js.default ./community/ami-code/conf/sendgrid.conf.js

# Set up and configure docker containers
cd $DIR
docker-compose build
docker-compose up -d

# Configure the CMS
echo "Waiting for a minute to make sure the MYSQL database is ready to be linked to the WP install"
sleep 60
docker-compose run --rm setup /home/wp-ami-setup.sh

# Install database for community tools
docker-compose exec community /data/install.sh

# Output final step to take
echo "Installation almost complete. Log into the CMS at http://localhost:8080/wp-login.php and enable qTranslate-x plugin."
echo "After that, visit http://localhost:3333 to check out the AMI frontend."