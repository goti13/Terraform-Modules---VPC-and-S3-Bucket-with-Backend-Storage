provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "My-VPC"
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "geraldotidemobucket-001234"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "my-state-lock-table"
  environment = "dev"
}