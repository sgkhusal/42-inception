include ./srcs/.env

COMPOSE_FILE		= ./srcs/docker-compose.yml
PROJECT_NAME		= inception

LOGIN				= sguilher
MY_DIR				= /home/$(LOGIN)
VOLUMES_DIR			= $(MY_DIR)/data

RM_DIR =	rm -rf

GREEN	=	\033[1;32m
RESET	=	\033[0m

all: up

up:	setup
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up -d

down:
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) down

rebuild: setup
	docker-compose -f $(COMPOSE_FILE) --project-name $(PROJECT_NAME) up --build

env:
	@echo "$(GREEN)Checking .env file...$(RESET)"
	@(grep "DB_WP_NAME" srcs/.env) || (echo "Missing .env file in srcs folder" && exit 1)

host:
	@echo "$(GREEN)Setting host...$(RESET)"
	@echo $(WP_DOMAIN)
	@sudo grep "$(WP_DOMAIN)" /etc/hosts || \
		(sudo cp /etc/hosts ./hosts_bkp && \
		echo "created hosts_bkp" && \
		sudo chmod 666 /etc/hosts && \
		sudo echo "127.0.0.1 $(WP_DOMAIN)" >> /etc/hosts && \
		sudo chmod 644 /etc/hosts && \
		echo "host setted")

setup: env host
	@echo "$(GREEN)Creating folder $(VOLUMES_DIR)...$(RESET)"
	@sudo mkdir -p $(MY_DIR)
	@sudo mkdir -p $(VOLUMES_DIR)
	@sudo mkdir -p $(VOLUMES_DIR)/mariadb
	@sudo mkdir -p $(VOLUMES_DIR)/wordpress
	@echo "folder created"

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
	@echo "$(GREEN)Removing volumes$(RESET)"
	@(docker volume ls | grep inception_mariadb && docker volume rm inception_mariadb) \
	|| echo "mariadb volume already deleted"
	@(docker volume ls | grep inception_wordpress && docker volume rm inception_wordpress) \
	|| echo "wordpress volume already deleted"
	@echo "$(GREEN)Removing images$(RESET)"
	@(docker image ls | grep nginx && docker rmi nginx) \
	|| echo "nginx image already deleted"
	@(docker image ls | grep mariadb && docker rmi mariadb) \
	|| echo "mariadb image already deleted"
	@(docker image ls | grep wordpress && docker rmi wordpress) \
	|| echo "wordpress image already deleted"
# docker network rm inception-network

fclean: clean
	@docker system prune --all --force --volumes
	@sudo $(RM_DIR) $(MY_DIR)
	@echo "$(GREEN)Restoring /etc/hosts$(RESET)"
	@sudo chmod 666 /etc/hosts
	@sudo cat ./hosts_bkp > /etc/hosts
	@sudo chmod 644 /etc/hosts
	@echo "/etc/hosts restored"

re: fclean all

.PHONY: all set_host up down rebuild srcs/.env clean fclean