# =============================================================================
# cloudwatch.tf — Log group for the API (very cheap at low volume)
# =============================================================================

resource "aws_cloudwatch_log_group" "api" {
  name              = "/cloud-native/${var.environment}/api"
  retention_in_days = 7 # short retention = lower cost for learning
}
