# Use a base Ubuntu image
# FROM ubuntu:22.04

# # Avoid interactive prompts during package installation
# ENV DEBIAN_FRONTEND=noninteractive

# # Install prerequisites and Ansible
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     ansible \
#     openssh-client \
#     python3 \
#     && rm -rf /var/lib/apt/lists/*

# # Set the working directory inside the container
# WORKDIR /project

# Start from a Python base image
#FROM python:3.9-slim
#
## Set the working directory inside the container
#WORKDIR /project
#
## Install ssh-client, then install specific versions of Ansible and the Docker SDK via pip
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends openssh-client && \
#    rm -rf /var/lib/apt/lists/* && \
#    pip install --no-cache-dir ansible-core==2.15.9 ansible==8.7.0 docker

# Use the official Nginx base image
#FROM nginx:alpine
#
## Remove the default Nginx welcome page
#RUN rm /usr/share/nginx/html/index.html
#
## Copy your custom application files into the Nginx web root
#COPY app/ /usr/share/nginx/html
#
## Inform Docker that the container listens on port 80
#EXPOSE 80

FROM nginx:alpine

# Copy your custom index.html file into the Nginx web root,
# overwriting the default welcome page.
COPY index.html /usr/share/nginx/html/index.html

# Inform Docker that the container listens on port 80
EXPOSE 80
