resource "aws_scheduler_schedule_group" "slack_metrics" {
  name = "slack-metrics-${var.env}"
}

resource "aws_scheduler_schedule" "sync_workspaces" {
  name                         = "sync-workspace-${var.env}"
  group_name                   = "slack-metrics-${var.env}"
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = "Asia/Tokyo"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = var.slack_metrics.ecs_cluster_arn
    input = jsonencode({
      containerOverrides = [{
        environment = [{
          name  = "TYPE"
          value = "sync-workspaces"
        }]
        name = "batch"
      }]
    })
    role_arn = var.slack_metrics.iam_role_arn
    ecs_parameters {
      launch_type         = "FARGATE"
      task_definition_arn = var.slack_metrics.ecs_task_definition_arn_without_revision
      network_configuration {
        assign_public_ip = false
        security_groups  = [var.slack_metrics.security_group_id]
        subnets          = var.subnet_ids
      }
    }
    retry_policy {
      maximum_event_age_in_seconds = 10800
      maximum_retry_attempts       = 3
    }
  }
}


resource "aws_scheduler_schedule_group" "cost_cutter" {
  name = "cost-cutter-${var.env}"
}

resource "aws_scheduler_schedule" "start_db_instance_cp" {
  group_name  = aws_scheduler_schedule_group.cost_cutter.name
  name        = "start-db-instance-cp-${var.env}"
  description = "Cloud PraticaのDBインスタンスを毎週火曜日の深夜1時45分に起動する。(RDSでは7日以上の停止ができないため)"

  schedule_expression          = "cron(45 1 ? * 2 *)"
  schedule_expression_timezone = "Asia/Tokyo"
  state                        = var.cost_cutter.enable ? "ENABLED" : "DISABLED"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:rds:startDBInstance"
    input = jsonencode({
      DbInstanceIdentifier = local.rds_identifier_cloud_pratica
    })
    role_arn = var.cost_cutter.iam_role_arn
    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "stop_db_instance_cp" {
  group_name  = aws_scheduler_schedule_group.cost_cutter.name
  name        = "stop-db-instance-cp-${var.env}"
  description = "Cloud PraticaのDBインスタンスを毎日深夜2時に停止する。"

  schedule_expression          = "cron(0 2 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  state                        = var.cost_cutter.enable ? "ENABLED" : "DISABLED"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:rds:stopDBInstance"
    input = jsonencode({
      DbInstanceIdentifier = local.rds_identifier_cloud_pratica
    })
    role_arn = var.cost_cutter.iam_role_arn
    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "stop_ec2_instances" {
  group_name  = aws_scheduler_schedule_group.cost_cutter.name
  name        = "stop-ec2-instances-${var.env}"
  description = "AWSアカウント内の全てのEC2インスタンスを毎日深夜2時に停止する。"

  schedule_expression          = "cron(0 2 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  state                        = var.cost_cutter.enable ? "ENABLED" : "DISABLED"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    input = jsonencode({
      InstanceIds = var.cost_cutter.ec2_instance_ids
    })
    role_arn = var.cost_cutter.iam_role_arn
    retry_policy {
      maximum_event_age_in_seconds = 3600 # 1 hour
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "scale_in_ecs_service_slack_metrics_api" {
  group_name                   = aws_scheduler_schedule_group.cost_cutter.name
  name                         = "scale-in-ecs-service-slack-metrics-api-${var.env}"
  description                  = "ECSサービス slack-metrics-api のタスク数を毎日深夜2時に0にする。"
  schedule_expression          = "cron(0 2 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  state                        = var.cost_cutter.enable ? "ENABLED" : "DISABLED"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    input = jsonencode({
      Cluster      = var.cost_cutter.ecs_cluster_arn_cloud_pratica_backend
      DesiredCount = 0
      Service      = "slack-metrics-api-${var.env}"
    })
    role_arn = var.cost_cutter.iam_role_arn
    retry_policy {
      maximum_event_age_in_seconds = 3600 # 1 hour
      maximum_retry_attempts       = 3
    }
  }
}
