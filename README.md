# Terraform-Modules---VPC-and-S3-Bucket-with-Backend-Storage

Purpose:

This mini project demostrates the use of Terraform to create modularized configurations for building an Amazon Virtual Private Cloud (VPC) and an Amazon S3 bucket. Additionally, we configured Terraform to use Amazon S3 as the backend.

Objectives:

1. Terraform Modules:

- Learn how to create and use Terraform modules for modular infrastructure provisioning.
2. VPC Creation:

- Build a reusable Terraform module for creating a VPC with specified configurations.

3. S3 Bucket Creation:

- Develop a Terraform module for creating an S3 bucket with customizable settings.

4. Backend Storage Configuration:

- Configure Terraform to use Amazon S3 as the backend storage for storing the Terraform state file.

Project Tasks:

Task 1: VPC Module

Project Tasks:

Task 1: VPC Module

1.    Create a new directory for your Terraform project (e.g.,' terraform-modules-vpc-s3').
2.    Inside the project directory, create a directory for the VPC module (e.g., modules/vpc*).
3.    Write a Terraform module ('modules/vpc/main.tf') for creating a VPC with customizable configurations such as CIDR block, subnets, etc.
4.    Create a main Terraform configuration file ('main. tf') in the project directory, and use the VPC module to create a VPC.


Task 2: S3 Bucket Module

1. Inside the project directory, create a directory for the S3 bucket module (e.g., ' modules/s3*).
2. Write a Terraform module ('modules/s3/main.tf*) for creating an $3 bucket with customizable configurations such as bucket name, ACL, etc.
3. Modify the main Terraform configuration file ("main.tf' ) to use the S3 module and create an S3 bucket.


Task 3: Backend Storage Configuration

1.    Configure Terraform to use Amazon S3 as the backend storage for storing the Terraform state file.
2.    Create a backend configuration file (e.g., ' backend.tf') specifying the S3 bucket and key for storing the state.
3.    Initialize the Terraform project using the command: 'terraform init'.
4.    Apply the Terraform configuration to create the VPC and S3 bucket using the command: terraform apply.

----------

Project File Structure:

```
terraform-modules-vpc-s3/
├── main.tf                 # Root configuration to use modules
├── backend.tf              # S3 backend configuration
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├
│   │   └── variables.tf
│   │
│   ├── s3/
│   │   ├── main.tf
│   │   ├
│   │   └── variables.tf
│   │
│   └── dynamodb/
│       ├── main.tf
│       ├
│       └── variables.tf
└── README.md               # Optional: project documentation

```


```
# main.tf
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
  bucket_name = "my-terraform-s3-bucket-123456"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "my-state-lock-table"
  environment = "dev"
}

```

--------
modules
--------


```
#module dynamodb
resource "aws_dynamodb_table" "terraform_locks" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "my-state-lock-table"
    Env = "Demo"
}

}

```

```
# module module dynamodb variable.tf

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default = "my-state-lock-table"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

```


```
# module s3

resource "aws_s3_bucket" "my_state_file_bucket" {
  bucket = var.bucket_name

  tags = {
    name = var.bucket_name
    Env = "Demo"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.my_state_file_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.my_state_file_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# (Optional) Bucket ownership controls for best practices
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.my_state_file_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


```

```

#module s3 variable.tf file

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "geraldotidemobucket-001234"
}

```

```
#module vpc


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

```

```
#module vpc variable.tf file

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}


```

![image](https://github.com/user-attachments/assets/57a666c5-11f6-402e-af28-2f41b02b57f9)


![image](https://github.com/user-attachments/assets/5b63d816-b809-4c2c-9f5b-bb15c326ccb9)

![image](https://github.com/user-attachments/assets/5ad225b9-80b2-4b8d-b54f-887a84fffd7c)

![image](https://github.com/user-attachments/assets/ac0099c6-afee-4bcb-b1a3-c0b5f53d324d)

![image](https://github.com/user-attachments/assets/6ee89a8d-287d-47a8-8577-46defa096b6a)


![image](https://github.com/user-attachments/assets/dc55a79f-c482-46de-945e-4db37b0cc5f8)


![image](https://github.com/user-attachments/assets/eb3710d6-432b-431e-b0c7-2341fb8c163e)

<img width="1329" alt="image" src="https://github.com/user-attachments/assets/b5f0e0d0-331b-44e1-86b8-448bae84667d" />

# Now adding the terraform backend.tf file

```

# backend.tf (backend configuration)
terraform {
  backend "s3" {
    bucket         = "geraldotidemobucket-001234"
    key            = "terraform/statefile/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-state-lock-table"
    use_lockfile = true
    encrypt = true
  }
}

```

![image](https://github.com/user-attachments/assets/ed838d0b-bf23-4de6-82cc-f80df3d69854)

![image](https://github.com/user-attachments/assets/a6d2ecb8-2dd9-4feb-9298-225e1d89f389)

![image](https://github.com/user-attachments/assets/2647503b-77a7-443d-bc51-e14e73641617)


<img width="1375" alt="image" src="https://github.com/user-attachments/assets/5220e909-a2a0-4787-b671-298e4dad70f7" />











