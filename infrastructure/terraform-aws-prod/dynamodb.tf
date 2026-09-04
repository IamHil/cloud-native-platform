# =============================================================================
# dynamodb.tf — On-demand billing (PAY_PER_REQUEST) = free-tier friendly
# =============================================================================

resource "aws_dynamodb_table" "files" {
  name         = "${local.name_prefix}-${var.dynamodb_files_table}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_id"

  attribute {
    name = "file_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "users" {
  name         = "${local.name_prefix}-${var.dynamodb_users_table}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }
}
