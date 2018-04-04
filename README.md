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
1. Two functions get appended to the default `twentyseventeen` Wordpress theme's `functions.php` file. One sets up CORS for all origins, which may not be suitable for production. The other function suppresses PHP error messages.

In order to complete the CMS configuration, some more steps are required:

1. Log into Wordpress admin using the credentials mentioned in `scripts/wp-ami-setup.sh`.
1. Go here: http://localhost:8080/wp-admin/admin.php?page=cptui_tools
1. Paste the contents from `scripts/custom-pot-types-export.json` into the import textarea and press "Import".
1. Go here: http://localhost:8080/wp-admin/options-permalink.php
1. Turn on the "Day and name" permalink structure option. The AMI API will break without url rewriting enabled through this method.
1. Visit the plugins page and enable qTranslate-X
1. Visit http://localhost:8080/wp-admin/options-general.php?page=qtranslate-x#general
1. Under URL Modification Mode, deselect "Hide URL language information for default language."
1. Visit http://localhost:8080/wp-admin/options-general.php?page=acf-qtranslate and check "Enable translation for Standard Field Types". Save changes.
1. Test the API by visiting http://localhost:8080/wp-json/. If it's a 404 there's a problem.

Now, set up some content to test out the API
1. Publish a jurisdiction. E.g. "Canada"
1. Publish an industry. E.g. "Telecom"
1. Publish an Operator Legal status. E.g. "Commercial"
1. Publish a request component. E.g. "location data"
1. Publish an indentifier. E.g. "email address"
1. Publish a Data operator service. E.g. "Mobile phone". Assign it a request component and identitifer.
1. Publish a data operator. E.g. "Rogers Communications". Assign it a logo, jurisdiction, services, an industry, and provide contact info.
1. Publish a request letter template. Simply put "Hello world" in the Body for now. Assign it a jurisdiction, industry, and operator status.

Note the ID for the jurisdiction. If you go to the post editing page for the jurisdiction, you'll see it in the URL for the page, where `post=<ID>`.

## Frontend configuration
1. Navigate to `frontend/ami-code/app/scripts/modules/config`.
1. There, edit `devConfig.js.default`. Change the value for `jurisdictionID` to the ID of the jurisdiction you created in the CMS. Save the file.
1. Now run `cp devConfig.js.default devConfig.js; cp devConfig.js prodConfig.js; cp devConfig.js localConfig.js`
1. Back in the project root, run `docker-compose build`. This will take awhile as the node_js libraries all get reinstalled (TODO: fix this?)
1. Run `docker-compose up`.
1. Visit http://localhost:9000
1. You should see the frontend, and see your created industry in the middle of the page, that you can click on. If you don't see the industry, check the CMS to make sure the "AMI API" and "Add Advance Custom Fields to JSON API" plugins are activated.

## TODO
Set up so you can edit locally files on the frontend and easily push them to the docker container.