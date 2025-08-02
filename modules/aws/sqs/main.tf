resource "aws_sqs_queue" "slack_metrics" {
  name                       = "slack-metrics-${var.env}"
  visibility_timeout_seconds = 3
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 60
}

resource "aws_sqs_queue_policy" "slack_metrics" {
  queue_url = aws_sqs_queue.slack_metrics.id
  policy = jsonencode({
    Id = "__default_policy_ID"
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = aws_sqs_queue.slack_metrics.arn
      Sid      = "__owner_statement"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_sqs_queue" "slack_metrics_dlq" {
  name = "slack-metrics-dlq-${var.env}"
}

resource "aws_sqs_queue_policy" "slack_metrics_dlq" {
  queue_url = aws_sqs_queue.slack_metrics_dlq.id
  policy = jsonencode({
    Id = "__default_policy_ID"
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = aws_sqs_queue.slack_metrics_dlq.arn
      Sid      = "__owner_statement"
    }]
    Version = "2012-10-17"
  })
}
