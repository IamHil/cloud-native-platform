# =============================================================================
# state.tf — Understanding Terraform State
# =============================================================================
#
# WHAT IS STATE?
#   After `terraform apply`, Terraform writes terraform.tfstate (local file).
#   It records every resource ID Terraform created so it knows what exists.
#
# WHY IT MATTERS:
#   terraform plan  → compares your .tf files AGAINST state
#   terraform apply → updates real infrastructure AND state together
#   terraform destroy → deletes resources listed in state
#
# RULES:
#   - Never edit terraform.tfstate by hand
#   - Never commit terraform.tfstate to git (contains sensitive data)
#   - If state is lost, Terraform forgets what it created
#
# OUR SETUP:
#   Local backend (default) — state file lives in this folder.
#   In Phase 10 (Production AWS) we'll move state to S3 for team use.
# =============================================================================

# No code needed here — state is created automatically on first `terraform apply`.
# This file exists as documentation for the "State" learning topic in Phase 7.
