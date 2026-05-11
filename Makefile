USER ?= yassine
DOCKER_USER ?= yass555
# If you update the images update the tag too
TAG ?= 1.1

API_IMAGE ?= $(DOCKER_USER)/todo-api:$(TAG)
MONGO_IMAGE ?= $(DOCKER_USER)/todo-mongodb:$(TAG)
NGINX_IMAGE ?= $(DOCKER_USER)/todo-nginx:$(TAG)

ANSIBLE_PLAYBOOK ?= Ansible/setup.yml
ANSIBLE_INVENTORY ?= Ansible/inventory.ini

.PHONY: build build-images push deploy up down logs create-volumes start stop remote-stop

build: create-volumes build-images push deploy

create-volumes:
	mkdir -p /home/$(USER)/data/nginx
	mkdir -p /home/$(USER)/data/mongodb
	mkdir -p /home/$(USER)/data/nodeAPI

build-images:
	docker build -t $(API_IMAGE) DockerContainers/API
	docker build -t $(MONGO_IMAGE) DockerContainers/MONGODB
	docker build -t $(NGINX_IMAGE) DockerContainers/NGINX

push:
	docker push $(API_IMAGE)
	docker push $(MONGO_IMAGE)
	docker push $(NGINX_IMAGE)

deploy:
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --ask-vault-pass

remote-stop:
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --ask-vault-pass --tags stop

remote-up:
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --ask-vault-pass --tags up

remote-down:
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --ask-vault-pass --tags down

up:
	docker compose -f ./DockerContainers/docker-compose.yml up -d --build

down:
	docker compose -f ./DockerContainers/docker-compose.yml down -v

start:
	docker compose -f ./DockerContainers/docker-compose.yml start

stop:
	docker compose -f ./DockerContainers/docker-compose.yml stop

logs:
	docker compose -f ./DockerContainers/docker-compose.yml logs --tail=100