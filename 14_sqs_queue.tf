resource "aws_sqs_queue" "standard_queue" {
  name = "interview-standard-queue"

  visibility_timeout_seconds = 30  # hide message from others for 30s after being read
  message_retention_seconds  = 86400  # keep message up to 1 day
  delay_seconds              = 0

  tags = {
    Purpose = "interview-demo"
  }
}


# FIFO
resource "aws_sqs_queue" "fifo_queue" {
  name                        = "interview-fifo-queue.fifo" # must end with .fifo
  fifo_queue                  = true
  content_based_deduplication = true

  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400

  tags = {
    Purpose = "interview-demo"
  }
}
