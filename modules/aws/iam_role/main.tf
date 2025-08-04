resource "aws_iam_role" "administrator" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::043309350350:root"
      }
    }]
    Version = "2012-10-17"
  })
  name = "administrator-${var.env}"
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = aws_iam_role.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role" "slack_metrics_backend" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
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
    }]
    Version = "2012-10-17"
  })
  name = "cp-db-migrator-${var.env}"
}

resource "aws_iam_role" "nat" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "cp-nat-${var.env}"
}

resource "aws_iam_role_policy_attachment" "nat" {
  for_each = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  policy_arn = each.value
  role       = aws_iam_role.nat.name
}

resource "aws_iam_role" "scheduler_cost_cutter" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "cp-scheduler-cost-cutter-${var.env}"
}

resource "aws_iam_role_policy_attachment" "scheduler_cost_cutter" {
  for_each = {
    ec2 = aws_iam_policy.ec2_start_stop.arn
    ecs = aws_iam_policy.ecs_write.arn
    rds = aws_iam_policy.rds_start_stop.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.scheduler_cost_cutter.name
}

resource "aws_iam_role" "scheduler_slack_metrics" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "cp-scheduler-slack-metrics-${var.env}"
}

resource "aws_iam_role_policy_attachment" "scheduler_slack_metrics" {
  for_each = {
    jobs          = aws_iam_policy.batch_submit_job.arn
    ecs           = aws_iam_policy.ecs_run_task.arn
    pass_role_ecs = aws_iam_policy.pass_role_ecs_to_ecs_task.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.scheduler_slack_metrics.name
}

resource "aws_iam_role" "slack_metrics_client" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "amplify.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "cp-slack-metrics-client-${var.env}"
}

resource "aws_iam_role_policy_attachment" "slack_metrics_client" {
  for_each = {
    logs = aws_iam_policy.cloud_watch_logs_write.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.slack_metrics_client.name
}

resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "ecs-task-execution-${var.env}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  for_each = {
    ecs_task_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    logs               = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    s3                 = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    secrets_manager    = aws_iam_policy.secrets_manager_read.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.ecs_task_execution.name
}
