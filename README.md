# WordPress Development With Docker

This repository contains tools and configurations to set up and manage WordPress projects using Docker. Below are frequently used commands categorized and explained to help streamline development.

## Table of Contents

- [WordPress Development With Docker](#wordpress-development-with-docker)
  - [Table of Contents](#table-of-contents)
  - [Build and Run Docker Image](#build-and-run-docker-image)
    - [Build WordPress Image](#build-wordpress-image)
    - [Build and Run in a Single Step](#build-and-run-in-a-single-step)
  - [Clean Up Docker Containers](#clean-up-docker-containers)
    - [Remove All Containers](#remove-all-containers)
  - [Launch Interactive Bash](#launch-interactive-bash)
    - [Access Bash Inside the Container](#access-bash-inside-the-container)
  - [Rebuild and Start with Docker Compose](#rebuild-and-start-with-docker-compose)
    - [Rebuild and Start Containers](#rebuild-and-start-containers)
  - [To-Do](#to-do)

---

## Build and Run Docker Image

### Build WordPress Image
```bash
DOCKER_BUILDKIT=1 docker build --progress=plain -t notalentgeek-wordpress-image .
```
**Explanation**: This command builds a Docker image for the WordPress project using BuildKit for better performance and debugging. The image is tagged as `notalentgeek-wordpress-image`.

### Build and Run in a Single Step
```bash
DOCKER_BUILDKIT=1 docker build --progress=plain -t notalentgeek-wordpress-image . && docker rm -f $(docker ps -aq); docker run -p 8080:80 --name notalentgeek-wordpress-container notalentgeek-wordpress-image
```
**Explanation**: Combines the build and run steps. It builds the image, removes all stopped containers, and runs the new image as a container, exposing it on port 8080.

---

## Clean Up Docker Containers

### Remove All Containers
```bash
docker rm -f $(docker ps -aq)
```
**Explanation**: Forcefully removes all Docker containers, regardless of their state, to ensure a clean environment.

---

## Launch Interactive Bash

### Access Bash Inside the Container
```bash
docker run -it --entrypoint /bin/bash notalentgeek-wordpress-image
```
**Explanation**: Starts a container with an interactive Bash session, allowing you to troubleshoot or inspect the container.

---

## Rebuild and Start with Docker Compose

### Rebuild and Start Containers
```bash
docker rm -f $(docker ps -aq); [ -d wordpress_data ] && rm -rf wordpress_data; [ -d db_data ] && rm -rf db_data; docker-compose up --build
```
**Explanation**: Stops and removes all containers, deletes existing WordPress and database data (if the `db_data` folder exists), and rebuilds the environment using `docker-compose`. Useful for starting fresh.

---

## To-Do

- (2025-01-28) Add commands to scaffold Sage theme during the first initialization of the WordPress container/service. Include this in `entrypoint.sh`.
- (2025-01-28) Change the WordPress installation into using WP CLI `wp core download`.

