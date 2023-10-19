COMPOSE_FILE		= ./srcs/docker-compose.yml
PROJECT_NAME		= inception

LOGIN				= sguilher
DOMAIN				= 127.0.0.1       $(LOGIN).42.fr
IS_DOMAIN_SETTED	= $(shell sudo grep "${DOMAIN}" /etc/hosts)
IS_ENV_CREATED		= $(shell cat srcs/.env)

MY_DIR				= /home/$(LOGIN)
VOLUMES_DIR			= $(MY_DIR)/data

RM_DIR =	rm -rf

all: up

up:	setup
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up

down:
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) down

rebuild: setup
	docker compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up --build

# srcs/.env:
# 	@if [ ${IS_ENV_CREATED} ]; then \
# 		echo "Env file exits, make sure all env vars are setted"; \
# 	else \
# 		echo "Missing .env file in srcs folder"; \
# 		exit 1; \
# 	fi
# 	@cat srcs/.env || (echo "Missing .env file in srcs folder" && exit 1)
# @grep CERT= srcs/.env || (echo "Missing CERT in .env" && echo 1)
# @grep CERT_KEY= srcs/.env || (echo "Missing CERT_KEY in .env" && echo 1)
# @grep DB_WP_NAME= srcs/.env || (echo "Missing DB_WP_NAME in .env" && echo 1)
# @grep DB_ROOT_PASSWORD= srcs/.env || (echo "Missing DB_ROOT_PASSWORD in .env" && echo 1)
# @grep DB_USER= srcs/.env || (echo "Missing DB_USER in .env" && echo 1)
# @grep DB_USER_PASSWORD= srcs/.env || (echo "Missing DB_USER_PASSWORD in .env" && echo 1)
# @grep WP_ADMIN= srcs/.env || (echo "Missing WP_ADMIN in .env" && echo 1)
# @grep WP_ADMIN_PASSWORD= srcs/.env || (echo "Missing WP_ADMIN_PASSWORD in .env" && echo 1)
# @grep WP_ADMIN_EMAIL= srcs/.env || (echo "Missing WP_ADMIN_EMAIL in .env" && echo 1)
# @grep WP_USER= srcs/.env || (echo "Missing WP_USER in .env" && echo 1)
# @grep WP_USER_EMAIL= srcs/.env || (echo "Missing WP_USER_EMAIL in .env" && echo 1)
# @grep WP_USER_PASSWORD= srcs/.env || (echo "Missing WP_USER_PASSWORD in .env" && echo 1)
# @grep WP_DOMAIN= srcs/.env || (echo "Missing WP_DOMAIN in .env" && echo 1)
# @grep WP_TITLE= srcs/.env || (echo "Missing WP_TITLE in .env" && echo 1)
# @grep WP_SUB_TITLE= srcs/.env || (echo "Missing WP_SUB_TITLE in .env" && echo 1)

set_host:
	@if [ ${IS_DOMAIN_SETTED} ]; then \
		echo "Host already setted"; \
	else \
		sudo cp /etc/hosts ./hosts_bkp; \
		sudo rm /etc/hosts; \
		sudo cp ./srcs/requirements/tools/hosts /etc/hosts; \
	fi

setup: set_host
	sudo mkdir -p $(MY_DIR)
	mkdir -p $(VOLUMES_DIR)
	mkdir -p $(VOLUMES_DIR)/mariadb
	mkdir -p $(VOLUMES_DIR)/wordpress
# sudo chown -R ${USER} $(MY_DIR)

exec-nginx:
	docker exec -it nginx bash

exec-mariadb:
	docker exec -it mariadb bash

exec-wordpress:
	docker exec -it wordpress sh

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f
log-nginx:
	docker-compose -f $(COMPOSE_FILE) logs -f nginx
log-mariadb:
	docker-compose -f $(COMPOSE_FILE) logs -f mariadb
log-wordpress:
	docker-compose -f $(COMPOSE_FILE) logs -f wordpress

clean: down
	docker volume rm inception_mariadb
	docker volume rm inception_wordpress
	docker rmi nginx:sguilher
	docker rmi mariadb:sguilher
	docker rmi wordpress:sguilher
	docker network rm inception-network

fclean: clean
	docker stop $(docker ps -a -q)
	docker rm -f $(docker ps -aq)
	docker rmi -f $(docker images -aq)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q)
	docker system prune -all --force --volumes
	sudo $(RM_DIR) $(MY_DIR)
	sudo chmod 666 /etc/hosts
	sudo cat ./hosts_bkp > /etc/hosts
	sudo chmod 644 /etc/hosts
	rm hosts_bkp
# docker image prune -f

re: fclean all

.PHONY: all set_host up down rebuild srcs/.env clean fclean