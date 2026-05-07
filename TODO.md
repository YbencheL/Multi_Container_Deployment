# Docker Compose Multi-Container Todo List Project

## Phase 1: Local API Development

### Node.js API Setup
- Initialize Node.js project with npm
- Install Express and Mongoose dependencies
- Install nodemon for development
- Setup MongoDB connection string configuration

### Create API Endpoints
- Implement GET /todos endpoint
- Implement POST /todos endpoint for creating todos
- Implement GET /todos/:id endpoint
- Implement PUT /todos/:id endpoint for updating todos
- Implement DELETE /todos/:id endpoint

### MongoDB Integration
- Design Todo schema with Mongoose
- Create Todo model
- Setup MongoDB connection with error handling
- Test all database operations

### API Testing
- Test all endpoints with Postman or curl
- Verify data is saved correctly in MongoDB
- Test error handling for invalid requests


## Phase 2: Dockerization

### Docker Setup for API
- Create Dockerfile for Node.js API
- Configure working directory and dependencies
- Expose port 3000
- Setup environment variables

### Docker Compose Configuration
- Create docker-compose.yml file
- Configure MongoDB service
- Configure Node.js API service
- Setup volume for MongoDB data persistence
- Setup environment variables for both services
- Configure networking between containers

### Local Testing with Docker Compose
- Build and run containers with docker-compose
- Verify API is accessible at http://localhost:3000
- Verify todos persist when containers are stopped and restarted
- Test all API endpoints from localhost:3000
- Check MongoDB data persistence


## Phase 3: Remote Server Setup

### Infrastructure with Terraform
- Create AWS or Digital Ocean account and setup credentials
- Write Terraform configuration for server creation
- Define VM specifications (CPU, RAM, storage)
- Setup security groups/firewall rules
- Configure SSH key pair for server access
- Create Terraform variables file
- Deploy infrastructure with Terraform

### Server Configuration with Ansible
- Create Ansible playbook for server setup
- Install Docker on remote server
- Install Docker Compose on remote server
- Configure Docker daemon
- Setup Docker Hub authentication
- Test connectivity to remote server

### Deploy Application to Remote
- Push Docker image to Docker Hub
- Create Ansible playbook to pull and run containers
- Deploy containers on remote server using docker-compose
- Verify API is running on remote server
- Test API endpoints on remote server


## Phase 4: CI/CD Pipeline

### GitHub Setup
- Create GitHub repository
- Push local code to GitHub
- Setup GitHub repository secrets for Docker Hub credentials
- Setup secrets for cloud provider credentials

### GitHub Actions Workflow
- Create workflow file (.github/workflows/deploy.yml)
- Setup build job to build Docker image
- Setup push job to push image to Docker Hub
- Setup test job to run API tests
- Setup deploy job using Terraform
- Setup deploy job using Ansible to run containers
- Configure workflow triggers (push to main branch)

### Pipeline Testing
- Make a code change and push to GitHub
- Verify GitHub Actions workflow runs
- Verify Docker image is built and pushed
- Verify remote server is updated
- Test API on remote server after deployment


## Phase 5: Bonus - Nginx Reverse Proxy

### Nginx Configuration
- Create Nginx configuration file
- Setup reverse proxy to forward requests to API container
- Configure SSL/TLS certificates
- Setup domain DNS records

### Docker Compose Update
- Add Nginx service to docker-compose.yml
- Configure Nginx container networking
- Setup volumes for Nginx config and SSL certificates
- Configure ports for HTTP and HTTPS

### Proxy Testing
- Test access via domain name (http://your_domain.com)
- Verify requests are forwarded to API correctly
- Verify HTTPS works if configured
- Test all API endpoints through proxy


## Documentation & Cleanup

### Documentation
- Create README.md with setup instructions
- Document environment variables needed
- Create deployment guide for remote server
- Document API endpoint examples

### Final Testing & Validation
- Test complete workflow from local to production
- Verify data persistence across all environments
- Document any issues or learnings
- Prepare project for submission
