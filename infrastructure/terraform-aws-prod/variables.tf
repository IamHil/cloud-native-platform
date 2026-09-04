# =============================================================================
# variables.tf — Inputs (with cost / safety guards)
# =============================================================================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming"
  type        = string
  default     = "cloud-native-platform"
}

variable "environment" {
  description = "Must be a non-production learning env until you are ready (dev)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod"
  }
}

variable "owner" {
  description = "Your name/email tag — helps identify who created resources (cost ownership)"
  type        = string
}

variable "confirm_real_aws" {
  description = "ALWAYS leave false. This learning repo does NOT create real AWS resources."
  type        = bool
  default     = false

  validation {
    # Hard block: even confirm_real_aws=true is rejected in this learning project.
    condition     = var.confirm_real_aws == false
    error_message = "APPLY DISABLED: This project is CODE-ONLY for Phase 10. Do NOT create real AWS services here. Study the .tf files / run terraform validate locally if you want — never terraform apply against a real account from this folder."
  }
}

variable "s3_bucket_prefix" {
  description = "Prefix for S3 bucket (a random suffix is added for global uniqueness)"
  type        = string
  default     = "cloud-native-uploads"
}

variable "dynamodb_files_table" {
  description = "DynamoDB table for file metadata"
  type        = string
  default     = "files"
}

variable "dynamodb_users_table" {
  description = "DynamoDB table for users"
  type        = string
  default     = "users"
}

variable "sqs_queue_name" {
  description = "SQS queue name for file processing"
  type        = string
  default     = "file-processing-queue"
}

# Expensive resources stay OFF by default (ALB, EC2, NAT, etc.)
variable "enable_ec2_demo" {
  description = "If true, create a tiny free-tier-friendly t3.micro EC2 (still can cost money)."
  type        = bool
  default     = false
}

variable "enable_alb" {
  description = "If true, create an Application Load Balancer (costs ~$16+/month). Keep false for learning."
  type        = bool
  default     = false
}

variable "allowed_cidr_ssh" {
  description = "CIDR allowed to SSH if EC2 demo is enabled (use YOUR IP/32, never 0.0.0.0/0)."
  type        = string
  default     = "127.0.0.1/32"
}

variable "budget_alert_email" {
  description = "Email for AWS budget alerts (required for cost safety)"
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly budget threshold in USD"
  type        = number
  default     = 5
}
