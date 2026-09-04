# =============================================================================
# provider.tf — REAL AWS provider (no LocalStack endpoints)
# =============================================================================
# Uses your AWS CLI profile / environment credentials.
# Example:
#   export AWS_PROFILE=your-dev-profile
#   terraform plan
# =============================================================================

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "random" {}
