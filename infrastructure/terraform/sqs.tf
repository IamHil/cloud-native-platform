# =============================================================================
# sqs.tf — SQS Queue for Async File Processing
# =============================================================================
#
# WHAT IS SQS?
#   Simple Queue Service — a message queue. Your API sends a message when a
#   file is uploaded; the worker polls the queue and processes it async.
#
# WHY TERRAFORM THIS?
#   Same reason as S3 and DynamoDB: define infrastructure declaratively.
#   Your sqs_service.py currently calls create_queue() on startup.
#   Terraform creates it once; the app just uses the queue URL.
#
# RESOURCE REFERENCE:
#   aws_sqs_queue.file_processing.url  → the queue URL your app needs
# =============================================================================

resource "aws_sqs_queue" "file_processing" {
  name = var.sqs_queue_name

  # How long a message is hidden after a worker picks it up (seconds).
  # If the worker crashes, the message becomes visible again after this time.
  visibility_timeout_seconds = 30

  # How long messages stay in the queue before expiring (seconds).
  # 4 days = 345600 seconds. Adjust based on your use case.
  message_retention_seconds = 345600
}
