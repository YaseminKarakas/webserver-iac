variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "environment" {
  description = "Environment name" 
  type        = string
}

variable "project_tag" {
  description = "Projects tag" 
  type        = string
}
