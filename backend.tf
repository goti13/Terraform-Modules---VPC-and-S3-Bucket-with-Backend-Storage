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