# AMI Docker

Access My Info (AMI) is a web application that makes it easy for people to create requests for access to their personal information.

This repository contains everything you need to get started developing AMI.

# Prerequisites
You'll need to have Docker installed on your computer.

# Installing AMI
To get started, simply clone this repository, and from the project root, run: `./install.sh`

The install script should take care of almost everything you need to set up the various AMI system components: It installs and configures Wordpress, which is the CMS / API for AMI. It also sets up the AMI frontend, which is an AngularJS application.

## Review
Once installation is complete:

1. Visit http://localhost:3333 to check out the frontend.
1. Visit http://localhost:8080 to check out the CMS.

# Development details
For more information about the AMI frontend application itself, check out that project's repository here: https://github.com/andrewhilts/ami