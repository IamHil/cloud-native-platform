# =============================================================================
# checks.tf — Safety Guards (LocalStack ONLY)
# =============================================================================
#
# WHY THIS FILE EXISTS:
#   You have access to production Terraform elsewhere. This folder must NEVER
#   accidentally touch real AWS. These checks run on every plan/apply and FAIL
#   if someone tries to point at production.
#
# WHAT IS A check BLOCK?
#   Terraform 1.5+ feature. Runs assertions before apply. If any fail,
#   Terraform stops with an error message — no resources are created.
# =============================================================================

check "localstack_only_environment" {
  assert {
    condition     = var.environment == "local"
    error_message = "SAFETY STOP: environment must be 'local'. This folder is LocalStack-only. Use a separate Terraform project for production AWS (Phase 10)."
  }
}

check "localstack_only_endpoint" {
  assert {
    condition     = local.is_localstack_endpoint
    error_message = "SAFETY STOP: aws_endpoint_url must point to LocalStack (e.g. http://localhost:4566). Real AWS endpoints are blocked in this project."
  }
}

check "localstack_only_credentials" {
  assert {
    condition     = var.aws_access_key_id == "test" && var.aws_secret_access_key == "test"
    error_message = "SAFETY STOP: Use credentials 'test'/'test' for LocalStack. Do not use real AWS access keys in infrastructure/terraform/."
  }
}

check "no_real_aws_in_endpoint" {
  assert {
    condition     = !can(regex("amazonaws\\.com", lower(var.aws_endpoint_url)))
    error_message = "SAFETY STOP: amazonaws.com detected in endpoint URL. This project refuses to run against real AWS."
  }
}
