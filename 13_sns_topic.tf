# SNS Topic
resource "aws_sns_topic" "alert_topic" {
  name = "interview-alert-topic"

  tags = {
    Purpose = "interview-demo"
  }
}

# Optional: Email subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}
