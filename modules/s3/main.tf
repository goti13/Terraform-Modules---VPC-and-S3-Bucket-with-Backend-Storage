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
