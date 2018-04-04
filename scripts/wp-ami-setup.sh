#!/bin/bash
cd /var/www/html
wp core install --url="localhost:8080" --title="WordPress" --admin_user="admin" --admin_password="prollynotadmin" --admin_email="admin@email.com"
wp plugin install "regenerate-thumbnails" "advanced-custom-fields" "wordpress-importer" "acf-qtranslate" "custom-post-type-ui" "qtranslate-x" "raw-html-snippets" "json-rest-api" "w3-total-cache" "https://github.com/andrewhilts/ami-api/archive/master.zip" "https://github.com/PanMan/WP-JSON-API-ACF/archive/master.zip" "https://github.com/hoppinger/advanced-custom-fields-wpcli/archive/master.zip" --activate
wp plugin activate ami-api
wp plugin activate WP-JSON-API-ACF
# # Fix PHP warning in qTranslate
patch wp-content/plugins/qtranslate-x/qtranslate_options.php /home/qtranslate_options.patch
wp eval-file /home/custom-post-types-import.php
wp import /home/default-content.xml --authors=skip
cat /home/cors.php >> wp-content/themes/twentyseventeen/functions.php
wp option update permalink_structure '/%year%/%monthnum%/%day%/%postname%/'
wp option add qtranslate_hide_default_language 0