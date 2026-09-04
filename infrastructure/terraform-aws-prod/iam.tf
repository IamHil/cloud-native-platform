# =============================================================================
# iam.tf — Least-privilege IAM role for the application
# =============================================================================
# The app should use this role (or keys from a user that assumes it),
# NOT your AWS root / admin account.
# =============================================================================

data "aws_iam_policy_document" "app_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "${local.name_prefix}-app-role"
  assume_role_policy = data.aws_iam_policy_document.app_assume.json
}

data "aws_iam_policy_document" "app_permissions" {
  statement {
    sid = "S3Uploads"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }

  statement {
    sid = "DynamoDB"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:DescribeTable",
    ]
    resources = [
      aws_dynamodb_table.files.arn,
      aws_dynamodb_table.users.arn,
    ]
  }

  statement {
    sid = "SQS"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.file_processing.arn]
  }

  statement {
    sid = "CloudWatchLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:/cloud-native/${var.environment}/*"]
  }
}

resource "aws_iam_role_policy" "app" {
  name   = "${local.name_prefix}-app-policy"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app_permissions.json
}

# Instance profile — attach to EC2 if/when enable_ec2_demo=true
resource "aws_iam_instance_profile" "app" {
  name = "${local.name_prefix}-app-profile"
  role = aws_iam_role.app.name
}
