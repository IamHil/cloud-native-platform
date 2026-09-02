# =============================================================================
# locals.tf — Local Values (Computed / Reusable Expressions)
# =============================================================================
#
# WHAT ARE LOCALS?
#   Locals are named expressions you can reference elsewhere in your code.
#   Think of them as private variables — they cannot be set from outside.
#
# LOCALS vs VARIABLES:
#   variable  → input FROM the user (tfvars, CLI, env)
#   local     → computed INSIDE the code (derived, reused expressions)
#
# SYNTAX:
#   locals {
#     name = expression
#   }
#   Reference: local.name  (note: singular "local", not "locals")
# =============================================================================

locals {
  # Tags applied to every resource via provider default_tags.
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Target      = "localstack" # makes it obvious in AWS console / LocalStack UI
  }

  # Allowed LocalStack endpoint patterns — used by checks.tf safety guards.
  # localhost / 127.0.0.1  → Terraform running on your machine
  # host.docker.internal   → Terraform on Windows/Mac when LocalStack is in Docker
  # localstack             → LocalStack service name inside Kubernetes/Docker network
  is_localstack_endpoint = (
    can(regex("^https?://(localhost|127\\.0\\.0\\.1|host\\.docker\\.internal)(:\\d+)?/?$", var.aws_endpoint_url)) ||
    can(regex("^https?://localstack", var.aws_endpoint_url))
  )
}
