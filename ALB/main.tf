resource "aws_lb" "webserver_alb" {
  name               = "webserver-alb-${var.project_tag}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver_alb_sg.id]
  subnets            = var.private_subnet_ids
  internal           = false 

  tags = {
    Environment      = var.environment
    Project          = var.project_tag
  }
}

resource "aws_security_group" "webserver_alb_sg" {
  name          = "webserver-alb-sg-${var.project_tag}"
  vpc_id        = var.vpc_id
  description   = "Security group for the Application Load Balancer"
  
  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["217.131.86.166/32"] # Or VPN CIDR
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

resource "aws_lb_target_group" "webserver_tg" {
  name          = "webserver-tg-${var.project_tag}"
  port          = var.container_port
  protocol      = "HTTP"
  target_type   = "ip"
  vpc_id        = var.vpc_id

  health_check {
    path        = var.health_check_path
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_tag
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn  = aws_lb.webserver_alb.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}
