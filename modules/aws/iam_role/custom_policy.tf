resource "aws_iam_policy" "s3_read" {
  name = "s3-read-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ses_send_email" {
  name = "ses-send-email-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "sqs_read_write" {
  name = "sqs-read-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

