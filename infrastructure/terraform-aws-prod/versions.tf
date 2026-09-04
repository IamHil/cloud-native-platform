# =============================================================================
# versions.tf — Terraform + AWS provider (REAL AWS — Phase 10)
# =============================================================================
# This folder is SEPARATE from infrastructure/terraform/ (LocalStack only).
# Never mix LocalStack and production configs in one directory.
# =============================================================================

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote state (recommended before sharing with a team).
  # Uncomment and fill when you are ready — until then, local state is fine
  # for learning, but DO NOT lose terraform.tfstate after apply.
  #
  # backend "s3" {
  #   bucket         = "YOUR-UNIQUE-TFSTATE-BUCKET"
  #   key            = "cloud-native-platform/prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}
