# Multi-Container Deployment

Automated deployment for a todo application using Docker, Ansible, and Terraform. The project builds the API, MongoDB, and Nginx images, deploys them with Docker Compose, and uses Ansible to provision and update the target server.

**Target Environment:** Ubuntu VM on Azure  
**Primary Access:** HTTPS through Nginx  
**Project Inspiration:** https://roadmap.sh/projects/configuration-management

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Structure](#project-structure)
3. [What Each Part Does](#what-each-part-does)
4. [Deployment](#deployment)
5. [Configuration](#configuration)
6. [Terraform Tutorial](#terraform-tutorial)
7. [Operations](#operations)

---

## API Container

- curl is installed in the API container for quick testing/debugging inside the container.

---


---

## Quick Start

```bash
# Install Ansible on the control machine
sudo apt install ansible

# Run the deployment
make deploy
```

---

## Project Structure

```text
Multi-Container/
├── Makefile
├── DockerContainers/
│   ├── API/
│   ├── MONGODB/
│   └── NGINX/
|   └── docker-compose.yml
├── Ansible/
│   ├── inventory.ini
│   ├── setup.yml
│   └── roles/
└── Terraform/
	├── main.tf
	├── variables.tf
	└── terraform.tfvars
```

---

## What Each Part Does

- `DockerContainers/API` contains the Node.js todo API.
- `DockerContainers/MONGODB` builds the MongoDB image used by the stack.
- `DockerContainers/NGINX` serves the site over HTTPS and proxies traffic.
- `Ansible` installs Docker, copies the compose setup, and runs deployment.
- `Terraform` manages the infrastructure layer when you want to provision or destroy Azure resources.

---

## Deployment

The usual local flow is:

```bash
make build
```

Or run the pieces manually:

```bash
docker build -t yass555/todo-api:1.1 DockerContainers/API
docker build -t yass555/todo-mongodb:1.1 DockerContainers/MONGODB
docker build -t yass555/todo-nginx:1.1 DockerContainers/NGINX

cd Ansible
ansible-playbook -i inventory.ini setup.yml --ask-vault-pass
```

---


## Notes

- Secrets are written from vault variables by Ansible, not copied from the repo.
- NGINX error page and static assets for `/blue` are served with an alias and redirect.
- Compose expects secrets in `./secrets/` next to the compose file.

---

## Terraform Tutorial

Use Terraform when you want to provision the Azure infrastructure for this project on your own account.

### 1. Configure Azure Credentials

Set your Azure environment variables before running Terraform:

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
```

Make sure your `Terraform/variables.tf` and `Terraform/terraform.tfvars` values match your VM, network, and access requirements,
All the configuration of the inferstracute will be done in the main.tf file.

### 2. Format and Initialize

```bash
cd Terraform
terraform fmt
terraform init
```

`terraform fmt` keeps the files consistent, and `terraform init` downloads the Azure provider and prepares the working directory.

### 3. Validate the Configuration

```bash
terraform validate
```

This checks that your Terraform files are syntactically valid before you try to create anything.

### 4. Review the Plan

```bash
terraform plan
```

Read the output carefully so you know exactly what Azure resources will be created, changed, or deleted.

### 5. Apply the Infrastructure

```bash
terraform apply
```

If you did not save a plan file, you can also run `terraform apply` directly, but using a saved plan is safer.

### 6. Useful Terraform Notes

- Keep Terraform focused on infrastructure, not application deployment.
- All terraform resources syntax and infos will be here :
```
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
```
- Re-run `terraform fmt`, `terraform validate`, and `terraform plan` after every change.
- Destroy resources with `terraform destroy` when you are done testing.

---

## Operations

### Makefile Targets

- `make build` — Build, push, and deploy images.
- `make up` — Start containers locally (development).
- `make down` — Stop and remove containers locally.
- `make start` — Start containers locally without rebuilding.
- `make stop` — Stop containers locally without removing.
- `make logs` — View the last 100 lines of container logs.
- `make deploy` — Deploy to the remote server via Ansible.
- `make remote-stop` — Stop containers on the remote server via Ansible.
- `make remote-up` — docker compose up via Ansible.
- `make remote-down` — docker compose down via Ansible.

### Managing the Remote Stack

Once deployed to the remote server, use `make remote-stop` to cleanly shut down all containers on the target server from your control machine. This runs the Ansible deployment playbook with the `--tags stop` flag, which stops the Docker Compose stack remotely.

---

---

## API Testing

**To test all the CRUD operation i recomment using postman with the following urls**:

- For getting all todos or creating a new one elements ```http://<YOUR_SERVERS_IP>:<PORT>/todos```.
- FOR getting a specific element or updating one ```http://<YOUR_SERVERS_IP>:<PORT>/todos/<ID>```.

*You can get an id of a todo by using GET to see all available todos in the Database, Additionally you can access
```https://<YOUR_SERVERS_IP>:<PORT>/todos``` to see all todos in the database, Or 
```https://<YOUR_SERVERS_IP>:<PORT>/todos/<ID>``` to look for a specific ID* since we have proxy redirection in nginx config file.

---

## Troubleshooting

- If Nginx serves old files, rebuild the Nginx image and redeploy the stack.
- If Ansible fails on vault prompts, verify the vault password and encrypted variables.

---

## Notes

- This repository is meant for learning multi-container deployment workflows.
- The Terraform layer is separate from the normal application deploy flow.
- Keep infrastructure provisioning and application rollout as distinct steps.
