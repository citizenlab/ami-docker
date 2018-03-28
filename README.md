# Docker Files to spin up Access My Info

So far this repo only manages the AMI Frontend component, but we'll add support for the others soon.

## Instructions:

Clone the AMI frontend in this repo's working directory:

`git clone git@github.com:andrewhilts/ami.git ami-code`

Copy over the config file defaults into actual files:

	cd ami-code/app/scripts/modules/config
	cp devConfig.js.default devConfig.js
	cp prodConfig.js.default prodConfig.js
	cp localConfig.js.default localConfig.js

Back in the project's parent directory, run:

`docker build -t ami-frontend .`

Then run:

`docker run -p 9000:9000/tcp -p 35729:35729/tcp ami-frontend`

Visit http://localhost:9000 in your browser

## Known issues:
1. It would be great to not have to bind ports 9000 and 35729 every time the command is run, but put it in the DockerFile
1. It would be great to be able to live-edit the code in ami-code and sync those changes with the container. This will the grunt livereload functionality kick in and speed up dev time.