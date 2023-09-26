FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y
# RUN mysql_secure_installation

CMD [service mariadb start]