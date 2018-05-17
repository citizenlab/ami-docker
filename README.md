# AMI Docker

Access My Info (AMI) is a web application that makes it easy for people to create requests for access to their personal information.

This repository contains everything you need to get started developing AMI.

## Table of Contents
1. [Access My Info](#access-my-info)
1. [Prerequisites](#prerequisites)
1. [Before installation](#before-installation)
1. [Installation](#installation)
1. [Configuration](#configuration)
2. [Development details](#development-details)

## Access My Info
[Access My Info](https://accessmyinfo.org) (AMI) is a web application that helps people to create legal requests for copies of their personal information from data operators. AMI is a step-by-step wizard that results in the generation of a personalized formal letter requesting access to the information that an operator stores and utilizes about a person.

AMI is made up of three components. The AMI frontend javascript app ("AMI Frontend"), the Wordpress CMS powering the frontend's content ("AMI CMS"), and the node.js app that powers the email and stats tracking system ("AMI Community Tools").

![AMI Architecture](docs/AMI-architecture.png)

*Figure 1: AMI Software Architecture*

## Prerequisites
You'll need to have [Docker](https://www.docker.com) installed on your computer and have some familiarilty with [the command line](https://www.codecademy.com/learn/learn-the-command-line). It will be helpful to have some experience with JavaScript applications.

## Before installation
To get started, open up your terminal and clone this repository.

Edit `scripts/wp-ami-setup.sh` and on line 3, replace the `admin` and `admin_password` values with your own.

## Installation
In your terminal, from the project root, run: `./install.sh`

The install script should take care of almost everything you need to set up the various AMI system components: It installs and configures Wordpress, which is the CMS / API for AMI. It also sets up the AMI frontend, which is an AngularJS application.

There are a few manual steps to take to fully set up and configure AMI after installation, which are described in the configuration section.

## Configuration

### Internationalization
**The AMI Frontend** can be internationalized by creating new JSON translation files in the `frontend/ami-code/app/translations` folder, with the naming convetion `{{two letter ISO language code}}-locale.json`.

You will then have to edit a few lines of `frontend/ami-code/app/scripts/modules/config/localConfig.js` the `supportedLanguages` array of language config objects to create an entry for your new language code. You may delete other language code entries here to remove them from the user interface.

**Ensure your changes has been synced with the Docker container by running `./sync.sh`**

**The AMI CMS** can be internationalized using the q-translateX plugin. Log into the CMS and go to the q-translateX plugin settings page. You can enable and disable languages here. Make sure the language code here corresponds to the language code you define in the frontend configuration. CMS post objects will have language tabs you can click on to edit different translations of the same content object.

### Email system
The foundation of AMI Community Tools' notification system is a concept called a jurisdiction event. Jurisdiction events are emails that are sent a specific number of days after a user has created a request in a particular jurisdiction.

For example, in Canada, one jurisdiction event might be to send a reminder to requesters 30 days after their request, asking if they've heard a response and providing helpful links if they haven't. After 60 days, another event might be an email with a survey link in it, asking for information about how the request process went.

To create events for a new jurisdiction, you'll have to create a new or edit the existing JSON file in the `jurisdiction_events` folder, with the naming convention `{{jurisdiction_id}}.json`, where `jurisdiction_id` is the ID of the jurisdiction in question in the AMI CMS. By default, the CMS uses ID 153 for its jurisdiction.

Each jurisdiction event file should have the following properties:

*  `jurisdiction_id` set to the ID of the jurisdiction in question in the AMI CMS
*  `events`: an array of objects representing jurisdiction events.

Each event object should have the following properties:

*  `id` a single word key for the event
*  `name` a full name for the event
*  `description` a description of the event
*  `days_to_reminder` an integer denoting the number of days following the creation of a request record that the notification will be sent
*  `email_template` the filename prefix for the email template to use in the notification. See the email template section below.

Here is a full juridicition_events record:

**153.json**

	{
		"jurisdiction_id": 153,
		"events": [
			{
				"id": "reminder",
				"name": "Check up on requester",
				"description": "This event sends a reminder email to the requester after the mandated period of time the operator has to respond has expired. Requester will be asked if they've gotten a response, sent a link to feedback form, or guidance on how to proceed if haven't gotten a response yet.",
				"days_to_reminder": 30,
				"email_template": "check-up"
			},
			{
				"id": "feedback",
				"name": "Solicit Feedback",
				"description": "Ask users for feedback if they haven't already provided it.",
				"days_to_reminder": 60,
				"email_template": "feedback"
			}
		]
	}

### Installing jurisdiction events
These events can be installed into the AMI Community system through 2 steps. 

1. Ensure your file has been synced with the Docker container by running `./sync.sh`
2. Run `docker-compose exec community /data/install-events.sh`

Once the events are installed, all future requests will be enrolled to receive email notifications for each jurisdiction event.

### Email API
AMI uses Sendgrid to send email notifications. You'll have to sign up for a Sendgrid account and edit `./community/ami-code/conf/sendgrid.conf.js` with your API key in order to send emails.

### Email templates
Email templates are used when sending out any email. Each email template is a folder following a specific naming convention, with an `html.handlebars`, and `text.handlebars` files inside.

Folders names have a single-word prefix, a hyphen, followed by a 2 word language code, another hyphen, then the jurisdiction ID. 

For example: `confirmation-en-153`

**This naming convention *must* be followed for the email templates to be found by the program.**

Within each email template folder, 2 files must exist: html.handlebars and text.handlebars

As the name indicates, the email template files use the [handlebars](http://handlebarsjs.com/) templating engine to populate the templates with variables (such as an unsubscribe link, the AMI logo, and more) when sending the message.

As the names of each file indicate, html.handlebars is used for HTML emails, while text.handlebars is for plaintext equivalents. Both are required.

### Cron job
Final step: create a cron job to automate sending reminder emails to requesters. The cron job will have to be set up on the Docker container and run the following command: `node /data/controllers/eventNotificationController/index.js`

## Review
Once installation is complete:

1. Visit [http://localhost:3333](http://localhost:3333) to check out the frontend.
1. Visit [http://localhost:8080/wp-login.php](http://localhost:8080/wp-login.php) to check out the CMS.
1. Visit [http://localhost:3214](http://localhost:3214) to check out the Community Tools.

## Development details
To make changes to the AMI frontend, you can edit the code on your host machine, in `frontend/ami-code/app` and then copy over the changes to the container by running `sync.sh` from the project root.

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

## Deploying to production
Todo...

## Troubleshooting
> Error: Error establishing a database connection. This either means that the username and password information in your `wp-config.php` file is incorrect or we can’t contact the database server at `mysql`. This could mean your host’s database server is down.

