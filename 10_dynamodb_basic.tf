provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "basic_table" {
  name           = "users_table"
  billing_mode   = "PAY_PER_REQUEST"  # On-demand (no need to set read/write capacity)

  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S" # "S" for string, "N" for number, "B" for binary
  }

  tags = {
    Environment = "dev"
    Purpose     = "interview-demo"
  }
}
