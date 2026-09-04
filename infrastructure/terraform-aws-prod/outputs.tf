# =============================================================================
# outputs.tf
# =============================================================================

output "s3_bucket_name" {
  description = "Upload bucket name — set as S3_BUCKET in the app"
  value       = aws_s3_bucket.uploads.bucket
}

output "dynamodb_files_table" {
  description = "Files table name — set as DYNAMODB_TABLE"
  value       = aws_dynamodb_table.files.name
}

output "dynamodb_users_table" {
  description = "Users table name — set as USERS_TABLE"
  value       = aws_dynamodb_table.users.name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.file_processing.url
}

output "sqs_queue_name" {
  description = "SQS queue name — set as SQS_QUEUE_NAME"
  value       = aws_sqs_queue.file_processing.name
}

output "app_iam_role_arn" {
  description = "Least-privilege IAM role for the application"
  value       = aws_iam_role.app.arn
}

output "cloudwatch_log_group" {
  description = "API log group name"
  value       = aws_cloudwatch_log_group.api.name
}

output "cost_reminder" {
  description = "Always destroy learning resources when done"
  value       = "When finished learning: terraform destroy. Confirm SNS budget email after apply."
}
