DOCKER_USER ?= yass555
# If you update the images update the tag too
TAG ?= 1.1

API_IMAGE ?= $(DOCKER_USER)/todo-api:$(TAG)
MONGO_IMAGE ?= $(DOCKER_USER)/todo-mongodb:$(TAG)
NGINX_IMAGE ?= nginx:my_nginx

ANSIBLE_PLAYBOOK ?= Ansible/setup.yml
ANSIBLE_INVENTORY ?= Ansible/inventory.ini

.PHONY: build build-images push deploy up down logs

build: build-images push deploy

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

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs --tail=100