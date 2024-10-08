terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create a Docker network
resource "docker_network" "my_network" {
  name = "my_network"
}


# Build PostgreSQL image
resource "docker_image" "postgres_image" {
  name         = "custom_postgres"
  build {
    context    = "./db"
    dockerfile = "./Dockerfile"
  }
}

# Create PostgreSQL container
resource "docker_container" "postgres_container" {
  name  = "postgres_container"
  image = docker_image.postgres_image.name
  ports {
    internal = var.db_port
    external = var.db_port
  }
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  networks_advanced {
    name = docker_network.my_network.name
  }
}

# Build Python script image
resource "docker_image" "python_image" {
  name         = "custom_python"
  build {
    context    = "./python-script"
    dockerfile = "./Dockerfile"
  }
}

# Create Python script container
resource "docker_container" "python_container" {
  name       = "python_container"
  image      = docker_image.python_image.name
  depends_on = [docker_container.postgres_container]
  env = [
    "DB_HOST=${var.db_host}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "DB_PORT=${var.db_port}"
  ]
  networks_advanced {
    name = docker_network.my_network.name
  }
}
