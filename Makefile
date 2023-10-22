include ./srcs/.env

COMPOSE_FILE		= ./srcs/docker-compose.yml
PROJECT_NAME		= inception

LOGIN				= sguilher
MY_DIR				= /home/$(LOGIN)
VOLUMES_DIR			= $(MY_DIR)/data

RM_DIR =	rm -rf

all: up

up:	setup
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up

down:
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) down

rebuild: setup
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up --build

env:
	@echo "Checking .env file..."
	(grep "DB_WP_NAME" srcs/.env) || (echo "Missing .env file in srcs folder" && exit 1)

host:
	@echo "Setting host..."
	@echo $(WP_DOMAIN)
	sudo grep "$(WP_DOMAIN)" /etc/hosts || \
		(sudo cp /etc/hosts ./hosts_bkp && \
		echo "created hosts_bkp" && \
		sudo chmod 666 /etc/hosts && \
		sudo echo "127.0.0.1 $(WP_DOMAIN)" >> /etc/hosts && \
		sudo chmod 644 /etc/hosts && \
		echo "host setted")

setup: env host
	sudo mkdir -p $(MY_DIR)
	sudo mkdir -p $(VOLUMES_DIR)
	sudo mkdir -p $(VOLUMES_DIR)/mariadb
	sudo mkdir -p $(VOLUMES_DIR)/wordpress

exec-server:
	docker exec -it nginx bash
# docker-compose exec nginx bash

exec-db:
	docker exec -it mariadb bash

exec-wp:
	docker exec -it wordpress sh

log-server:
	docker logs -f nginx
log-db:
	docker logs -f mariadb
log-wp:
	docker logs -f wordpress

clean: down
	docker volume rm inception_mariadb
	docker volume rm inception_wordpress
	docker rmi nginx
	docker rmi mariadb
	docker rmi wordpress
# docker network rm inception-network

fclean: clean
	docker system prune --all --force --volumes
	@sudo $(RM_DIR) $(MY_DIR)
	@sudo chmod 666 /etc/hosts
	@sudo cat ./hosts_bkp > /etc/hosts
	@sudo chmod 644 /etc/hosts
	@echo "/etc/hosts restored"

re: fclean all

.PHONY: all set_host up down rebuild srcs/.env clean fclean