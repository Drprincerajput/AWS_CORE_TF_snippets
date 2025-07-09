provider "aws" {
  region = "us-east-1"
}

# Lambda Role
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-http-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda ZIP with inline code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_http.zip"
  source {
    content  = <<EOF
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from HTTP API!"
    }
EOF
    filename = "index.py"
  }
}

resource "aws_lambda_function" "http_lambda" {
  function_name    = "http_lambda"
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "python3.12"
  handler          = "index.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# HTTP API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api-demo"
  protocol_type = "HTTP"
  target        = aws_lambda_function.http_lambda.arn
}

# Lambda permission to allow HTTP API invoke
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowHTTPAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Output the invoke URL
output "http_api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}
