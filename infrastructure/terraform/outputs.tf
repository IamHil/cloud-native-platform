# =============================================================================
# outputs.tf — Output Values (Information Terraform Shows After Apply)
# =============================================================================
#
# WHAT ARE OUTPUTS?
#   After `terraform apply`, Terraform prints output values.
#   They're useful for:
#     - Copying values into your .env or k8s ConfigMap
#     - Passing to other Terraform modules (Phase 10+)
#     - Quick verification that resources were created
#
# SYNTAX:
#   output "name" {
#     description = "What this value means"
#     value       = expression referencing resources
#   }
#
# VIEW OUTPUTS ANYTIME:
#   terraform output
#   terraform output s3_bucket_name
# =============================================================================

output "s3_bucket_name" {
  description = "Name of the S3 bucket for file uploads"
  value       = aws_s3_bucket.uploads.bucket
}

output "s3_bucket_arn" {
  description = "ARN (Amazon Resource Name) — unique identifier in AWS"
  value       = aws_s3_bucket.uploads.arn
}

output "dynamodb_files_table_name" {
  description = "DynamoDB table for file metadata"
  value       = aws_dynamodb_table.files.name
}

output "dynamodb_users_table_name" {
  description = "DynamoDB table for user accounts"
  value       = aws_dynamodb_table.users.name
}

output "sqs_queue_url" {
  description = "URL the API/worker use to send and receive messages"
  value       = aws_sqs_queue.file_processing.url
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue"
  value       = aws_sqs_queue.file_processing.arn
}

# Sensitive outputs can be marked so they don't print in the terminal.
# Example for later when we manage real secrets:
# output "db_password" {
#   value     = aws_db_instance.main.password
#   sensitive = true
# }
