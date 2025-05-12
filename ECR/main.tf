resource "aws_ecr_repository" "ecr_webserver" {
  name              = "webserver"
  force_delete      = true                            # TODO: Set it true to destroy with terraform destroy

  image_scanning_configuration {
    scan_on_push    = true
  }
  
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment     = var.environment
    Project         = var.project_tag
  }
}
/*
resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
      docker tag ${var.webserver_docker_image_name}:${var.webserver_docker_image_tag} ${aws_ecr_repository.ecr_webserver.repository_url}:latest
      docker push ${aws_ecr_repository.ecr_webserver.repository_url}:latest
    EOT
  }
  depends_on = [aws_ecr_repository.ecr_webserver]
}*/     