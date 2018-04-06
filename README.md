# AMI Docker

Access My Info (AMI) is a web application that makes it easy for people to create requests for access to their personal information.

This repository contains everything you need to get started developing AMI.

## Prerequisites
You'll need to have Docker installed on your computer.

## Installing AMI
To get started, simply open up your terminal, clone this repository, and from the project root, run: `./install.sh`

The install script should take care of almost everything you need to set up the various AMI system components: It installs and configures Wordpress, which is the CMS / API for AMI. It also sets up the AMI frontend, which is an AngularJS application.

The only manual step to take is to log into the CMS after it's installed (the install script will let you know) and enable the `qtranslate-X` plugin.

### Review
Once installation is complete:

1. Visit http://localhost:3333 to check out the frontend.
1. Visit http://localhost:8080 to check out the CMS.

## Development details
To make changes to the AMI frontend, you can edit the code on your host machine, in `frontend/ami-code/app` and then copy over the changes to the container by running `sync.sh`

The frontend dev server is set to live reload upon file changes, so you should see your browser refresh immediately after running the command.

To make livereload even better, set up your IDE or a script to watch for file changes and run `sync.sh` after every file save. With Visual Studio Code this can be accomplished with the `emeraldwalk.runonsave` plugin and the following workspace preference entry:

	{
		"emeraldwalk.runonsave": {
			"commands": [
				{
					"match": "frontend/ami-code/app/.*",
					"isAsync": true,
					"cmd": "${workspaceRoot}/sync.sh"
				}
			]
		}
	}

## Frontend Documentation
For more information about the AMI frontend application itself, check out that project's repository here: https://github.com/andrewhilts/ami