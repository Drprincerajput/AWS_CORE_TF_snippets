resource "aws_ssm_parameter" "app_env" {
  name  = "/myapp/env"
  type  = "String"
  value = "dev"

  tags = {
    Purpose = "interview-demo"
  }
}
