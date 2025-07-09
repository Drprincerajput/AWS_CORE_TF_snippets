provider "aws" {
  region = "us-east-1"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function (inline Python)
resource "aws_lambda_function" "my_lambda" {
  function_name = "interview_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "python3.12"
  handler       = "index.lambda_handler"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Create zip with inline Python
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_function.zip"

  source {
    content  = <<EOF
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }
EOF
    filename = "index.py"
  }
}
