# =============================================================================
# localstack.auto.tfvars — AUTO-LOADED LocalStack settings (committed to git)
# =============================================================================
#
# Terraform automatically loads *.auto.tfvars files — no -var-file flag needed.
# These values LOCK this project to LocalStack. Do not change to production values.
#
# If you need production AWS, create a SEPARATE folder (Phase 10), e.g.:
#   infrastructure/terraform-aws-prod/
# =============================================================================

environment           = "local"
aws_endpoint_url      = "http://localhost:4566"
aws_access_key_id     = "test"
aws_secret_access_key = "test"
