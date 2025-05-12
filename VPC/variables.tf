variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_tag" {
  description = "Projects tag" 
  type        = string
}

variable "environment" {
  description = "Environment name" 
  type        = string
}