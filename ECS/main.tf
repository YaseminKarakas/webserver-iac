# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster_webserver_iac" {
  name = "ecs-cluster-${var.project_tag}"

  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

# Security Group for webserver Service
resource "aws_security_group" "webserver_ecs_sg" {
  name        = "${var.service_name_webserver}-sg-${var.project_tag}"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

# ECS Service
resource "aws_ecs_service" "webserver_ecs_service" {
  name            = "${var.service_name_webserver}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster_webserver_iac.id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_instances          
  launch_type     = "FARGATE"
  
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "container-${var.service_name_webserver}"
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.private_subnet_ids 
    security_groups  = [aws_security_group.webserver_ecs_sg.id]
    assign_public_ip = false
  }

  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}
