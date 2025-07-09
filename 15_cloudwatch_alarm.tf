resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-ec2-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60   # 60 seconds
  statistic           = "Average"
  threshold           = 70

  alarm_description   = "Triggered when EC2 CPU > 70% for 2+ minutes"
  dimensions = {
    InstanceId = aws_instance.example.id
  }

  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alert_topic.arn]  # Step 13 SNS
  ok_actions          = [aws_sns_topic.alert_topic.arn]

  tags = {
    Purpose = "interview-demo"
  }
}
