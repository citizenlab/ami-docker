#!/bin/bash
cd /var/www/html
wp core install --url="localhost:8080" --title="WordPress" --admin_user="admin" --admin_password="prollynotadmin" --admin_email="admin@email.com"
wp plugin install "regenerate-thumbnails" "advanced-custom-fields" "wordpress-importer" "acf-qtranslate" "custom-post-type-ui" "raw-html-snippets" "https://github.com/WP-API/WP-API/archive/1.2.5.zip" "w3-total-cache" "https://github.com/citizenlab/ami-api/archive/master.zip" "https://github.com/PanMan/WP-JSON-API-ACF/archive/master.zip" "https://github.com/hoppinger/advanced-custom-fields-wpcli/archive/master.zip" --activate
wp plugin install "qtranslate-x"
wp plugin activate ami-api
wp plugin activate WP-JSON-API-ACF
# # Fix PHP warning in qTranslate
wp eval-file /home/custom-post-types-import.php
wp eval-file /home/raw-html-snippets-import.php
wp import /home/default-content.xml --authors=skip
cat /home/cors.php >> wp-content/themes/twentyseventeen/functions.php
wp option update permalink_structure '/%year%/%monthnum%/%day%/%postname%/'
wp option add qtranslate_hide_default_language 0