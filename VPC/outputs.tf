output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  value       = aws_vpc.main.cidr_block
}