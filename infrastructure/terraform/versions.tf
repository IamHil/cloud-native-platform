# =============================================================================
# versions.tf — Terraform & Provider Version Constraints
# =============================================================================
#
# WHY THIS FILE EXISTS:
#   Terraform needs to know WHICH version of itself to use, and WHICH versions
#   of providers (plugins) are allowed. This prevents surprise breaking changes
#   when someone runs `terraform init` on a different machine.
#
# SYNTAX:
#   terraform { }     → settings about Terraform itself (version, backend, etc.)
#   required_version  → minimum Terraform CLI version allowed
#   required_providers → map of provider names → version constraints
#
# VERSION CONSTRAINT OPERATORS:
#   ~> 5.0   means ">= 5.0.0 and < 6.0.0"  (allow patch updates only)
#   >= 1.6   means "1.6.0 or higher"
#   = 5.40   means "exactly 5.40.x"
# =============================================================================

terraform {
  # Require Terraform CLI 1.6+ (modern syntax and features)
  required_version = ">= 1.6.0"

  required_providers {
    # The AWS provider is a plugin that knows how to talk to AWS APIs.
    # Terraform core is cloud-agnostic; providers do the actual API calls.
    aws = {
      source  = "hashicorp/aws" # official provider on registry.terraform.io
      version = "~> 5.0"        # any 5.x version is fine
    }
  }

  # ---------------------------------------------------------------------------
  # STATE BACKEND (commented out for now — we use local state by default)
  # ---------------------------------------------------------------------------
  # Terraform stores a "state file" that tracks what it created.
  # By default it lives in terraform.tfstate on your machine (local backend).
  #
  # In production you'd store state remotely (S3 + DynamoDB locking).
  # We'll learn that later in Phase 10. For now, local state is fine.
  #
  # backend "s3" {
  #   bucket         = "my-terraform-state"
  #   key            = "cloud-native/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}
