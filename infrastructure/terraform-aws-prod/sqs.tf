# =============================================================================
# sqs.tf — Standard queue (cheap at low volume)
# =============================================================================

resource "aws_sqs_queue" "file_processing" {
  name                       = "${local.name_prefix}-${var.sqs_queue_name}"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
}
