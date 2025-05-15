variable "aws_region" {
  description = "AWS region to create resources in"
  default     = "eu-central-1"                          # TODO: Set your desired region
}

variable "account_id" {
  description = "AWS Accounnt ID"
  default     = "767397888348"                                    # TODO: Set your account id
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "Environment name"
  default     = "dev"                                 # TODO: Set an environment (dev/prod/uat)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]        # TODO: Set private subnet CIDR blocks
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]    # TODO: Set public subnet CIDR blocks
}

variable "project_tag" {
  description = "Projects tag" 
  type        = string
  default     = "webserver-iac"                            # TODO: Set to your project's name
}

variable "service_name_webserver" {
  description = "Service name for webserver" 
  type        = string
  default     = "webserver"
}

variable "webserver_docker_image_name" {
  description = "Docker image name for the webserver container"
  type        = string
  default     = "nginxdemos/hello"                    # TODO: Set to your local docker image name
}

variable "webserver_docker_image_tag" {
  description = "Docker image tag for the webserver container"
  type        = string
  default     = "latest"                              # TODO: Set to your local docker image tag
}

variable "container_port" {
  description = "Container port exposed in webserver service"
  type        = number
  default     = 80                               # TODO: Set to the exposed port number on pdf-creator container
}

variable "health_check_path" {
  description = "Health check path for webserver service"
  type        = string
  default     = "/health"                                   # TODO: Set to the preferred health check path for pdf-creator container
}

variable "ecs_min_instances" {
  description = "Minimum number of instances in the ECS cluster"
  type        = number
  default     = 1                                     # TODO: Set to the minimum number of instances required to run in ECS
}

variable "ecs_max_instances" {
  description = "Maximum number of instances in the ECS cluster"
  type        = number
  default     = 1                                     # TODO: Set to the maximum number of instances required to run in ECS
}

variable "ecs_desired_instances" {
  description = "Desired number of instances in the ECS cluster"
  type        = number
  default     = 1                                    # TODO: Set to the desired number of instances required to run in ECS
}

variable "ecs_task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256                                # TODO: Set to the amount of cpu required for your task
}

variable "ecs_task_memory" {
  description = "Memory for the task"
  type        = number
  default     = 512                                 # TODO: Set to the amount of memory required for your task
}
