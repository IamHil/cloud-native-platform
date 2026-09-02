# =============================================================================
# variables.tf — Input Variables (Parameters for Your Infrastructure)
# =============================================================================
#
# WHAT ARE VARIABLES?
#   Variables are like function parameters. They let you reuse the same
#   Terraform code with different values (dev vs prod, LocalStack vs AWS).
#
# SYNTAX:
#   variable "name" {
#     description = "Human-readable explanation"
#     type        = string | number | bool | list | map | object
#     default     = optional fallback value
#   }
#
# HOW VALUES GET SET (priority order, highest wins):
#   1. Command line:  terraform apply -var="aws_region=eu-west-1"
#   2. Variable file: terraform.tfvars  (or -var-file=other.tfvars)
#   3. Environment:   TF_VAR_aws_region=eu-west-1
#   4. default =      in this file
# =============================================================================

# --- Connection settings (LocalStack) ----------------------------------------

variable "aws_region" {
  description = "AWS region. LocalStack accepts any region; us-east-1 is standard."
  type        = string
  default     = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "LocalStack API endpoint ONLY. Must be localhost or host.docker.internal — never amazonaws.com."
  type        = string
  default     = "http://localhost:4566"

  validation {
    condition     = !can(regex("amazonaws\\.com", lower(var.aws_endpoint_url)))
    error_message = "SAFETY: Real AWS endpoints are not allowed. Use http://localhost:4566 for LocalStack."
  }
}

variable "aws_access_key_id" {
  description = "Must be 'test' for LocalStack. Real AWS keys are blocked by safety checks."
  type        = string
  default     = "test"

  validation {
    condition     = var.aws_access_key_id == "test"
    error_message = "SAFETY: aws_access_key_id must be 'test' for LocalStack-only Terraform."
  }
}

variable "aws_secret_access_key" {
  description = "Must be 'test' for LocalStack. Real AWS keys are blocked by safety checks."
  type        = string
  default     = "test"

  validation {
    condition     = var.aws_secret_access_key == "test"
    error_message = "SAFETY: aws_secret_access_key must be 'test' for LocalStack-only Terraform."
  }
}

# --- Project metadata --------------------------------------------------------

variable "project_name" {
  description = "Project name used in resource tags and naming."
  type        = string
  default     = "cloud-native-platform"
}

variable "environment" {
  description = "Must be 'local' — this Terraform folder is LocalStack-only."
  type        = string
  default     = "local"

  validation {
    condition     = var.environment == "local"
    error_message = "SAFETY: environment must be 'local'. Production uses a separate Terraform project."
  }
}

# --- Resource names (must match your app's config.py / k8s ConfigMap) ----------

variable "s3_bucket_name" {
  description = "S3 bucket for uploaded files. Matches S3_BUCKET in the app."
  type        = string
  default     = "cloud-native-uploads"
}

variable "dynamodb_files_table" {
  description = "DynamoDB table for file metadata. Matches DYNAMODB_TABLE in the app."
  type        = string
  default     = "files"
}

variable "dynamodb_users_table" {
  description = "DynamoDB table for user accounts. Matches USERS_TABLE in the app."
  type        = string
  default     = "users"
}

variable "sqs_queue_name" {
  description = "SQS queue for async file processing. Matches SQS_QUEUE_NAME in the app."
  type        = string
  default     = "file-processing-queue"
}
