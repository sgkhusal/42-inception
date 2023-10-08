FROM debian:bullseye
# FROM debian:bullseye-slim

RUN apt update -y && apt install -y mariadb-server
	# procps \
	# vim \
	# mariadb-server

# will be set in another place
# ENV DB_NAME=inception
# ENV DB_ROOT_PASSWORD=password
# ENV DB_USER=user42
# ENV DB_USER_PASSWORD=user42

# copy configuration files
# COPY ./conf/mariadb.cnf /etc/mysql/mariadb.cnf
# COPY ./conf/my.cnf ~/.my.cnf
# COPY ./conf/my.cnf /etc/mysql/my.cnf
# ~/.my.cnf is the last file readed for configs
# it overrides any previously defined option
COPY ./conf/my2.cnf .
RUN cat my2.cnf >> /etc/mysql/my.cnf && rm my2.cnf
# RUN echo "\n[mariadb]\nbind-address=0.0.0.0\nport=3306\n" >> /etc/mysql/my.cnf
# RUN echo "socket=/var/lib/mysql/mysql.sock\n" >> /etc/mysql/my.cnf

RUN mkdir /run/mysqld
RUN chmod 777 /run/mysqld
# RUN chown mysql:mysql
# check right permissions - adicionar mysql no grupo correto - grupo mysql


COPY ./tools/db-setup.sh .
RUN chmod +x ./db-setup.sh
RUN ./db-setup.sh

EXPOSE 3306

STOPSIGNAL SIGQUIT
# STOPSIGNAL SIGTERM

# ensure that db server starts with the necessary safety checks and configs
# and also with mariadb in foreground
CMD [ "mysqld_safe" ]
# CMD [ "mysqld" ]
# CMD [ "sh", "-c", "sleep infinity" ]