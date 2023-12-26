# s3 bucket

resource "aws_s3_bucket" "backend" {
  bucket = "backend-tf001"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
    }
  }
}
# dyanmo db table
resource "aws_dynamodb_table" "Dynamodb_t" {
  name             = "state_lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  

  attribute {
    name = "LockID"
    type = "S"
  }
}