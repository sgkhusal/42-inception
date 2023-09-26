DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

VOLUMES_DIR = /home/sguilher/data

RM_DIR =	rm -rf

up:	setup
	docker compose -f $(DOCKER_COMPOSE_FILE) up
# -f or --file: docker compose file

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f
log-nginx:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f nginx
log-mariadb:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f mariadb
log-wordpress:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f wordpress


setup:
	sudo mkdir -p $(VOLUMES_DIR)
	sudo chown -R ${USER} $(VOLUMES_DIR)
	mkdir -p $(VOLUMES_DIR)/mariadb
	mkdir -p $(VOLUMES_DIR)/wordpress

fclean:
	$(RM_DIR) $(VOLUMES_DIR)
