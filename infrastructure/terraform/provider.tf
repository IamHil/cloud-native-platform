# =============================================================================
# provider.tf — Configure HOW Terraform Talks to AWS
# =============================================================================
#
# ⚠️  LOCALSTACK ONLY — DO NOT USE FOR PRODUCTION AWS
#
# This entire folder (infrastructure/terraform/) is locked to LocalStack.
# Safety checks in checks.tf will BLOCK plan/apply if you try to use real AWS.
# Production Terraform will be a separate project in Phase 10.
#
# WHAT IS A PROVIDER?
#   A provider is a plugin that translates Terraform code into API calls.
#   `provider "aws"` means: "use the AWS plugin for all aws_* resources."
#
# WHY POINT AT LOCALSTACK?
#   Our app runs against LocalStack (fake AWS on localhost:4566).
#   The AWS provider normally calls real AWS — we override the endpoints
#   so Terraform creates resources inside LocalStack instead.
# =============================================================================

provider "aws" {
  region = var.aws_region

  # Explicit test credentials — never reads ~/.aws/credentials or AWS_PROFILE.
  # Using hardcoded "test" keys ensures we cannot accidentally auth to real AWS.
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key

  # LocalStack does not validate credentials like real AWS does.
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # ALL AWS API calls go to LocalStack — not amazonaws.com.
  endpoints {
    s3       = var.aws_endpoint_url
    dynamodb = var.aws_endpoint_url
    sqs      = var.aws_endpoint_url
    iam      = var.aws_endpoint_url
    sts      = var.aws_endpoint_url
  }

  s3_use_path_style = true

  default_tags {
    tags = local.common_tags
  }
}
