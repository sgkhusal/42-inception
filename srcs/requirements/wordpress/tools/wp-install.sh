#!/bin/bash

if ! wp core is-installed --path=/var/www/wordpress/ --allow-root; then

	# install wordpress and create admin user
    wp core install \
        --allow-root \
        --path=/var/www/wordpress/ \
        --url="$WP_DOMAIN" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
		--skip-email

	# create second user
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --path=/var/www/wordpress/ \
        --allow-root

	# ensure plugins are updated
	wp plugin update --all --allow-root --path=/var/www/wordpress

	# ensure right permissions and ownership
	chown -R www-data:www-data /var/www/wordpress
	chmod -R 775 /var/www/wordpress
fi

exec "$@"