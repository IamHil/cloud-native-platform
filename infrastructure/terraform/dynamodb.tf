# =============================================================================
# dynamodb.tf — DynamoDB Tables
# =============================================================================
#
# WHAT IS DYNAMODB?
#   AWS's NoSQL database. Each table has a primary key (partition key).
#   Our app has two tables:
#     - files  → keyed by file_id  (file metadata)
#     - users  → keyed by email    (user accounts)
#
# KEY CONCEPTS:
#   hash_key     → the partition key column name
#   attribute {} → declares column name + type (S=string, N=number, B=binary)
#   billing_mode → PAY_PER_REQUEST = no capacity planning (good for learning)
#
# TERRAFORM vs YOUR APP:
#   Your Python services (dynamodb_service.py, user_service.py) currently
#   call create_table() on startup. Once Terraform manages tables, the app
#   should only READ/WRITE — not create infrastructure. (We'll refactor later.)
# =============================================================================

resource "aws_dynamodb_table" "files" {
  name         = var.dynamodb_files_table
  billing_mode = "PAY_PER_REQUEST" # on-demand pricing; no read/write units to set
  hash_key     = "file_id"         # partition key — must match your app's KeySchema

  # Every key used in KeySchema must be declared here first.
  attribute {
    name = "file_id"
    type = "S" # S = String
  }
}

resource "aws_dynamodb_table" "users" {
  name         = var.dynamodb_users_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }
}
