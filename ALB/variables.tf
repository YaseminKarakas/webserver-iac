variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "project_tag" {
  description = "Projects tag" 
  type        = string
}

variable "container_port" {
  description = "Container port exposed in webserver service"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for webserver service"
  type        = string
}