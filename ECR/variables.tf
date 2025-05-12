variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
}

variable "account_id" {
  description = "AWS Accounnt ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_tag" {
  description = "Project name"
  type        = string
}

variable "webserver_docker_image_tag" {
  description = "Docker image tag of the webserver container"
  type        = string
}

variable "webserver_docker_image_name" {
  description = "Docker image name of the webserver container"
  type        = string
}