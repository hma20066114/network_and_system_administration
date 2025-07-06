# This configuration does not create any new infrastructure.
# It only connects to an existing server to deploy an application.

# Define the AWS provider and region.
provider "aws" {
  region = "eu-north-1" # Or your preferred region
}

# --- Input Variables ---
variable "ec2_host_ip" {
  description = "The public IP address of the existing EC2 instance."
  type        = string
}

variable "docker_image_tag" {
  description = "The tag of the Docker image to deploy."
  type        = string
}

# --- Deployment Resource ---
# This is a special resource that doesn't create anything.
# We use it as a hook to run our deployment script.
resource "null_resource" "deploy_fitness_app" {

  # This block tells Terraform how to connect to your existing instance.
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./testing-1.pem") # IMPORTANT: Make sure your .pem file is in this directory.
    host        = var.ec2_host_ip
  }

  # This provisioner runs a script on the instance after connecting.
  # It replicates the exact steps from our Ansible playbook.
  provisioner "remote-exec" {
    inline = [
      "echo '--- Starting Deployment ---'",
      "sudo apt-get update -y",
      "sudo apt-get install -y ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu focal stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      
      # Stop and remove any old container to prevent port conflicts
      "sudo docker stop fitness-website || true",
      "sudo docker rm fitness-website || true",
      
      # Pull the specific version of your application image
      "sudo docker pull htoomyata468/fitness-app:${var.docker_image_tag}",
      
      # Run the new container with the specific tag
      "sudo docker run -d --name fitness-website -p 80:80 --restart always htoomyata468/fitness-app:${var.docker_image_tag}",
      "echo '--- Deployment Complete ---'"
    ]
  }

  # This trigger ensures the deployment re-runs if the image tag changes.
  triggers = {
    image_tag = var.docker_image_tag
  }
}
