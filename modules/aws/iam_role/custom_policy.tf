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

resource "aws_iam_policy" "ec2_start_stop" {
  name = "ec2-start-stop-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_write" {
  name = "ecs-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "ecs:UpdateService",
        "ecs:RunTask"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_run_task" {
  name = "ecs-run-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "ecs:RunTask"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "pass_role_ecs_to_ecs_task" {
  name = "pass-role-to-ecs-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "iam:PassRole"
      ],
      Condition = {
        StringEquals = {
          "iam:PassedToService" = "ecs-tasks.amazonaws.com"
        }
      },
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "rds_start_stop" {
  name = "rds-start-stop-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "rds:StopDBInstance",
        "rds:StartDBInstance"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_policy" "batch_submit_job" {
  name = "batch-submit-job-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "batch:SubmitJob"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "cloud_watch_logs_write" {
  name = "cloud-watch-logs-write-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "secrets_manager_read" {
  name = "secrets-manager-read-${var.env}"
  policy = jsonencode({
    Statement = [{
      "Action" : [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

