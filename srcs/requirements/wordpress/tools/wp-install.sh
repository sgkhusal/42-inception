#!/bin/bash

if ! wp core is-installed --path=/var/www/wordpress/ --allow-root; then
    wp core install \
        --allow-root \
        --path=/var/www/wordpress/ \
        --url="$WP_DOMAIN" \
        --title="Inception blog" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=subscriber \
        --user_pass=$WP_USER_PASSWORD \
        --path=/var/www/wordpress/ \
        --allow-root
fi