Automated Deployment of a Web Application on AWS
----------------------------------------------------
This repository contains the complete code and configuration for a project that demonstrates an end-to-end automated deployment of a containerized web application onto AWS infrastructure. The project utilizes a modern DevOps toolchain to handle everything from infrastructure provisioning to continuous deployment.







Architecture Diagram
-----------------------
The following diagram illustrates the complete workflow, from a developer committing code to the application being served to the end-user.

<img width="1266" height="543" alt="image" src="https://github.com/user-attachments/assets/d3d23686-264b-489d-8d79-605f3d2c2150" />


Technologies Used
-----------------------
Cloud Provider: Amazon Web Services (AWS)

Infrastructure as Code: Terraform

Configuration Management: Ansible

Containerization: Docker

CI/CD Pipeline: GitHub Actions


How to Run Manually
---------------------------
These steps allow you to deploy the entire stack from your local machine without using the CI/CD pipeline.

Prerequisites
--------------------------
AWS Account and configured AWS CLI

Terraform installed

Ansible installed

An EC2 Key Pair created in your AWS account

Step 1: Provision Infrastructure with Terraform
Navigate to the project directory.

Edit main.tf: Replace your-key-pair-name with the name of your EC2 key pair.

Initialize Terraform:

terraform init

Apply the configuration:

terraform apply

When prompted, type yes. Terraform will create the resources and output the public IP address of the EC2 instance.

Step 2: Build and Push the Docker Image
Log in to Docker Hub:

docker login

Build the image:

docker build -t your-dockerhub-username/fitness-app:latest .

Push the image:

docker push your-dockerhub-username/fitness-app:latest

Step 3: Configure and Deploy with Ansible
Edit inventory.ini:

Replace YOUR_EC2_IP_HERE with the IP address from the Terraform output.

Ensure the path to your .pem key file is correct.

Edit playbook.yml:

Ensure the community.docker.docker_image and community.docker.docker_container tasks are using the correct image name (e.g., your-dockerhub-username/fitness-app:latest).

Run the playbook:

ansible-playbook -i inventory.ini playbook.yml

After the playbook completes, your website will be live at the EC2 instance's public IP address.

CI/CD Pipeline Automation
This project includes a fully automated CI/CD pipeline using GitHub Actions, defined in the .github/workflows/deploy.yml file.

How it Works
Trigger: The pipeline automatically starts on any git push to the main branch.

Build Job:

Checks out the code.

Builds a new Docker image from the Dockerfile.

Tags the image with the unique Git commit SHA for versioning.

Pushes the newly tagged image to Docker Hub.

Deploy Job:

Waits for the Build job to succeed.

Installs Ansible.

Sets up an SSH key to connect to the EC2 instance.

Runs the playbook.yml, passing the new, unique Docker image tag as a variable. This ensures the latest version of the code is always deployed.

Configuration
------------------
For the pipeline to work, the following secrets must be configured in your GitHub repository under Settings > Secrets and variables > Actions:

DOCKERHUB_USERNAME: Your Docker Hub username.

DOCKERHUB_TOKEN: A Docker Hub access token with write permissions.

EC2_HOST: The public IP address of your EC2 instance.

EC2_SSH_KEY: Your private SSH key (.pem file content).
