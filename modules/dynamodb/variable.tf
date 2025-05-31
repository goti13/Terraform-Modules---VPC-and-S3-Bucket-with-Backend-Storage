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
