resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/ecs-cluster-${var.project_tag}"
  retention_in_days = 7
  
  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecsTaskRole-${var.service_name_webserver}"
  assume_role_policy = jsonencode({
    Version          = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

#Attach the policies to the execution role
/*resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  for_each   = toset(var.iam_policies_task)

  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.value
}*/

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecsExecutionRole-${var.service_name_webserver}"
  assume_role_policy = jsonencode({
    Version          = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

#Attach the policies to the execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  for_each   = toset(var.iam_policies_execution)

  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = each.value
}

resource "aws_ecs_task_definition" "webserver_task_definition" {
  family                   = "${var.service_name_webserver}-task-definiton"
  network_mode             = "awsvpc" 
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn                        # This role is used by the ECS agent and Docker daemon to run the container.
  task_role_arn            = aws_iam_role.ecs_task_role.arn                             # This role is used by the container to access other AWS services.
  
  container_definitions    = jsonencode([{
    name      = "container-${var.service_name_webserver}"
    cpu       = var.task_cpu
    memory    = var.task_memory
    image     = "${var.ecr_repository_url}:${var.webserver_docker_image_tag}"
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options   = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "container-${var.service_name_webserver}"
      }
    }
  }])

  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}