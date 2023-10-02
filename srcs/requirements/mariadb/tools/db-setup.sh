#!/bin/bash

service mariadb start

DB_PATH=/var/lib/mysql/$DB_NAME

if [ -d "$DB_PATH" ]; then
	echo "$DB_NAME database is already created"
else
	echo "Running mysql secure installation"
	mysql_secure_installation << EOF
$DB_ROOT_PASSWORD
n
n
n
n
n
EOF

	echo "Creating database $DB_NAME..."
	mariadb -u root -p $DB_ROOT_PASSWORD -e << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';

	# mysql -uroot -p $DB_ROOT_PASSWORD $DB_NAME < wordpress.sql ;
	# mysqladmin -uroot -psenha shutdown;
	service mariadb stop
fi