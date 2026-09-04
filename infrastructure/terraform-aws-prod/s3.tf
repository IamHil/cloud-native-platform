# =============================================================================
# s3.tf — Upload bucket (pay only for storage + requests — usually cheap for learning)
# =============================================================================

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "uploads" {
  # Bucket names must be globally unique in real AWS
  bucket = "${var.s3_bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"

  # Allow terraform destroy during learning. Turn off for real prod data.
  force_destroy = var.environment != "prod"
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  versioning_configuration {
    # Keep off for learning to avoid storage cost from old versions
    status = "Disabled"
  }
}
