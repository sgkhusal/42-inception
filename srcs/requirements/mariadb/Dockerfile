FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y
# RUN mysql_secure_installation

# RUN service mariadb start

EXPOSE 3306

STOPSIGNAL SIGQUIT

CMD [ "sh", "-c", "sleep infinity" ]