#!/bin/bash

# start mariadb in background
service mariadb start
# start mariadb on foreground
# myslqd

DB_PATH="/var/lib/mysql/$DB_WP_NAME"

if [ -d "$DB_PATH" ]; then
	echo "$DB_WP_NAME database is already created"
else
	echo "Running mysql secure installation"
	mysql_secure_installation << EOF

n
y
$DB_ROOT_PASSWORD
$DB_ROOT_PASSWORD
y
y
n
y
EOF
# Enter current password for root (enter)
# Switch to unix_socket authentication (= a user in localhost OS equals to a user in the db can connect without a password) (n)
# Change the root password? (y)
# New password:
# Re-enter new password:
# Remove anonymous users? (y)
# Disallow root login remotely? (y)
# Remove test database and access to it? (n)
# Reload privilege tables now? (y)

	echo "Creating database $DB_WP_NAME..."
	cat << EOF > user-conf
CREATE DATABASE IF NOT EXISTS $DB_WP_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
	mariadb -u root -p $DB_ROOT_PASSWORD < user-conf
	rm user-conf
# GRANT ALL PRIVILEGES ON $DB_WP_NAME.* TO '$DB_USER'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';

	# mysql -uroot -p $DB_ROOT_PASSWORD $DB_WP_NAME < wordpress.sql ;
	# mysqladmin -uroot -psenha shutdown;
fi

service mariadb stop

# mariadb:
# CREATE USER 'user42'@'%' IDENTIFIED BY 'user42';
# GRANT ALL PRIVILEGES ON *.* TO 'user42'@'%';
# FLUSH PRIVILEGES;

# nginx:
#     1  apt install mariadb-client -y
#     2  mariadb -h mariadb -u user42 -puser42 # -P 3306
# should not work:
#     3  mariadb
#     4  mariadb -h localhost -> 127.0.0.1 (connect to a database server running on the same machine)
#     5  mariadb -h mariadb
#     6  mariadb -h mariadb -u root

