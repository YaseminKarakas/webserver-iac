variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
}

variable "task_memory" {
  description = "Memory for the task"
  type        = number
}

variable "project_tag" {
  description = "Project tag for resource tagging"
  type        = string
}

variable "service_name_webserver" {
  description = "Service name for PDF Creator"
  type        = string
}

variable "ecr_repository_url" {
  description = "value"
  type        = string
}

variable "container_port" {
  description = "Container port exposed in PDF Creator service"
  type        = number
}

variable "webserver_docker_image_tag" {
  description = "Docker image tag for the pdf-creator container"
  type        = string
}

/*
variable "iam_policies_task" {
  description = "List of IAM policies to attach to the ECS Task Role"                   # TODO: Add the list of IAM Policies needed for the containers inside the task.
  type        = list(string)                                                            #       For example access to the services like RDS, S3, Bedrock.
}
*/

variable "iam_policies_execution" {
  description = "List of IAM policies to attach to the ECS Execution Role"              # TODO: Add the list of IAM Policies needed for the ECS Agent to run the container.
  type        = list(string)                                                            #       Often used for pulling container images from ECR,
                                                                                        #       fetching secrets from Secrets Manager or
                                                                                        #       sending logs to CloudWatch.
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}