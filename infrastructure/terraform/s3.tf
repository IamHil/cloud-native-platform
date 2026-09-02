# =============================================================================
# s3.tf — S3 Bucket for File Uploads
# =============================================================================
#
# WHAT IS A RESOURCE?
#   A `resource` block tells Terraform to CREATE and MANAGE something.
#   Syntax:  resource "PROVIDER_TYPE" "LOCAL_NAME" { ... }
#
#   - PROVIDER_TYPE  → aws_s3_bucket (defined by the AWS provider)
#   - LOCAL_NAME     → uploads (your nickname, used to reference this bucket)
#   - Reference it:  aws_s3_bucket.uploads.bucket
#
# TERRAFORM vs YOUR APP:
#   Right now your Python app creates the bucket at startup (s3_service.py).
#   With Terraform, WE create it first — the app just uses it.
#   That's Infrastructure as Code: infra is defined in .tf files, not app code.
# =============================================================================

resource "aws_s3_bucket" "uploads" {
  # bucket name must be globally unique in real AWS.
  # In LocalStack, any name works.
  bucket = var.s3_bucket_name
}

# -----------------------------------------------------------------------------
# Optional: prevent accidental deletion of the bucket
# -----------------------------------------------------------------------------
# In production you'd enable this. For learning, we leave it off so
# `terraform destroy` can clean up easily.
#
# resource "aws_s3_bucket_lifecycle_configuration" "uploads" { ... }
