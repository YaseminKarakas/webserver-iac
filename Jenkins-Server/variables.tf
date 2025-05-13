variable "public_subnet_ids" {
  description = "List of public Subnet IDs"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block of the vpc"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS tasks will run"
  type        = string
}

variable "environment" {
  description = "Environment name" 
  type        = string
}

variable "project_tag" {
  description = "Projects tag" 
  type        = string
}