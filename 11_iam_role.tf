resource "aws_iam_role" "lambda_dynamodb_role" {
  name = "lambda-dynamodb-role"

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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb_rw_policy" {
  name = "lambda-dynamodb-rw"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ],
        Resource = aws_dynamodb_table.basic_table.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_dynamodb_policy" {
  name       = "attach-lambda-dynamodb-rw"
  roles      = [aws_iam_role.lambda_dynamodb_role.name]
  policy_arn = aws_iam_policy.dynamodb_rw_policy.arn
}
