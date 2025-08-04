resource "aws_iam_role" "slack_metrics_backend" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  name = "cp-slack-metrics-backend-${var.env}"
}

resource "aws_iam_role_policy_attachment" "slack_metrics_backend" {
  for_each = {
    ssm  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    logs = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    s3   = aws_iam_policy.s3_read.arn
    ses  = aws_iam_policy.ses_send_email.arn
    sqs  = aws_iam_policy.sqs_read_write.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.slack_metrics_backend.name
}

resource "aws_iam_role" "bastion" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  name = "cp-bastion-${var.env}"
}

resource "aws_iam_role_policy_attachment" "bastion" {
  for_each = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  policy_arn = each.value
  role       = aws_iam_role.bastion.name
}

resource "aws_iam_role" "db_migrator" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  name = "cp-db-migrator-${var.env}"
}
