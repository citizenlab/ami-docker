# AMI Docker

# Initial set up
From the project root run `git clone https://github.com/andrewhilts/ami frontend/ami-code`.

Run `cd ami-code; git checkout webpack`

Run `docker-compose build` to start with. This will get a basic WordPress install running, along with the dependencies for the frontend.

Now run `docker-compose up -d`, which will start up the containers.

## CMS configuration
Now configure the Wordpress install, by running `docker-compose run --rm setup /home/wp-ami-setup.sh`. This will do the following:

1. Finish the Wordpress setup wizard programatically.
1. Install required plugins.
1. An advanced custom field configuation gets imported that provides field definitions for all sorts of AMI domain concepts.
1. Custom field types get defined.
1. Default content gets imported
1. Two functions get appended to the default `twentyseventeen` Wordpress theme's `functions.php` file. One sets up CORS for all origins, which may not be suitable for production. The other function suppresses PHP error messages.
1. The qTranslate-x plugin gets patched to fix an error.


## Frontend configuration
1. Navigate to `frontend/ami-code/app/scripts/modules/config`.
1. There, edit `localConfig.js.default`. The value for `jurisdictionID` should already correspond to the ID of the jurisdiction imported into the CMS during the initial configuration. Save the file.
1. Copy `localConfig.js.default` to `localConfig.js`
1. From the project root, run `docker cp ./frontend/ami-code/app amidocker_frontend_1:/data/`. This should copy over the changes you've made to the code.

## Review
1. Visit http://localhost:3333 to check out the frontend.
1. Visit http://localhost:8080 to check out the CMS.

## TODO
Set up so you can edit locally files on the frontend and easily push them to the docker container.