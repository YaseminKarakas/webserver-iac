# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      version = ">= 5.26.0"
      source  = "hashicorp/aws"
    }
  }
}

# VPC Module
module "vpc" {
  source         = "./VPC"
  vpc_cidr_block = var.vpc_cidr_block
  environment    = var.env
  project_tag    = var.project_tag
}

# Subnets Module
module "subnets" {
  source          = "./Subnets"
  vpc_id          = module.vpc.vpc_id
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  environment     = var.env
  project_tag     = var.project_tag
}


# Application Load Balancer Module
module "alb" {
  source                = "./ALB"
  environment           = var.env
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.subnets.public_subnet_ids
  private_subnet_ids    = module.subnets.private_subnet_ids
  project_tag           = var.project_tag
  vpc_cidr_block        = var.vpc_cidr_block
  container_port        = var.container_port
  health_check_path     = var.health_check_path
}


# ECS Task Definition Module
module "ecs_task_definition" {
  source              = "./ECS-TaskDefinition"
  environment         = var.env
  region              = var.aws_region
  task_cpu            = var.ecs_task_cpu
  task_memory         = var.ecs_task_memory
  project_tag         = var.project_tag
  ecr_repository_url  = module.ecr.ecr_repository_url
  
  #Container environment variables
  service_name_webserver     = var.service_name_webserver
  container_port             = var.container_port
  webserver_docker_image_tag = var.webserver_docker_image_tag
}

# ECS Module
module "ecs" {
  source                  = "./ECS"
  environment             = var.env
  account_id              = var.account_id
  private_subnet_ids      = module.subnets.private_subnet_ids
  vpc_id                  = module.vpc.vpc_id
  alb_security_group_id   = module.alb.alb_security_group_id
  task_definition_arn     = module.ecs_task_definition.task_definition_arn
  target_group_arn        = module.alb.target_group_arn
  project_tag             = var.project_tag
  min_instances           = var.ecs_min_instances
  desired_instances       = var.ecs_desired_instances
  max_instances           = var.ecs_max_instances
  container_port          = var.container_port
}


# ECS Module
module "ecr" {
  source                        = "./ECR"
  environment                   = var.env
  aws_region                    = var.aws_region
  account_id                    = var.account_id
  webserver_docker_image_name   = var.webserver_docker_image_name
  webserver_docker_image_tag    = var.webserver_docker_image_tag
  project_tag                   = var.project_tag
}