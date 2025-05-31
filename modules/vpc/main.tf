
resource "aws_vpc" "my-demo-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my-demo-vpc.id
}