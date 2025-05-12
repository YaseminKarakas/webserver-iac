variable "account_id" {
  description = "AWS Accounnt ID"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS tasks will run"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  type        = list(string)
}

variable "min_instances" {
  description = "Minimum number of instances in the ECS cluster"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances in the ECS cluster"
  type        = number
}

variable "desired_instances" {
  description = "Desired number of instances in the ECS cluster"
  type        = number
}

variable "project_tag" {
  description = "Project tag for resource tagging"
  type        = string
}

variable "service_name_webserver" {
  description = "Service name for webserver service"
  type        = string
  default     = "webserver"
}

variable "container_port" {
  description = "Container port exposed in webserver service"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the ECS Task Definition from ECS-TaskDefinition"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for ALB"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}
