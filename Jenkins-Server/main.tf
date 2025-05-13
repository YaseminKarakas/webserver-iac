resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block] # Or VPN CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-06d4d7b82ed5acff1" # Amazon Linux 2
  instance_type          = "t3.small"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  iam_instance_profile   = aws_iam_instance_profile.jenkins_ssm_profile.name

  tags = {
    Environment = var.environment
    Name = "jenkins-server"
    Project     = var.project_tag
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker

              docker run -d \
                -p 8080:8080 \
                -p 50000:50000 \
                --name jenkins \
                -v jenkins_home:/var/jenkins_home \
                jenkins/jenkins:lts
            EOF
}

resource "aws_iam_role" "jenkins_ssm_role" {
  name = "jenkins-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ssm_policy" {
  role       = aws_iam_role.jenkins_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "jenkins_ssm_profile" {
  name = "jenkins-ec2-ssm-profile"
  role = aws_iam_role.jenkins_ssm_role.name
}
