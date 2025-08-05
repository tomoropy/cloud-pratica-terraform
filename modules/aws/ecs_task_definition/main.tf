resource "aws_ecs_task_definition" "db_migrator" {
  family                   = "db-migrator-${var.env}"
  cpu                      = var.ecs_task_specs.db_migrator.cpu
  memory                   = var.ecs_task_specs.db_migrator.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn_db_migrator
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    environment = []
    environmentFiles = [{
      type  = "s3"
      value = "${var.arn_cp_config_bucket}/db-migrator-${var.env}.env"
    }]
    essential = true
    image     = "${var.ecr_url_db_migrator}"
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/db-migrator-stg"
        awslogs-region        = "ap-northeast-1"
        awslogs-stream-prefix = "ecs"
      }
    }
    name = "app"
    secrets = [{
      name      = "DB_HOST"
      valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
      }, {
      name      = "DB_PASSWORD"
      valueFrom = "${var.secrets_manager_arn_db_main_instance}:operator_password::"
      }, {
      name      = "DB_USER"
      valueFrom = "${var.secrets_manager_arn_db_main_instance}:operator_user::"
    }]
  }])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_task_definition" "slack_metrics_api" {
  family                   = "slack-metrics-api-${var.env}"
  cpu                      = var.ecs_task_specs.slack_metrics_api.cpu
  memory                   = var.ecs_task_specs.slack_metrics_api.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn_slack_metrics
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "${var.ecr_url_slack_metrics}"
      essential = true
      portMappings = [
        {
          hostPort      = 8080
          containerPort = 8080
        }
      ]
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
        },
      ]
      environmentFiles = [
        {
          type  = "s3"
          value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/api/health || exit 1"]
        interval    = 30
        timeout     = 5
        startPeriod = 0
        retries     = 3
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/slack-metrics-api-${var.env}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "ap-northeast-1"
        }
      }
      readonlyRootFilesystem = true
    },
    {
      name         = "worker"
      image        = "${var.ecr_url_slack_metrics}"
      essential    = true
      portMappings = []
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
        },
      ],
      environment = [
        {
          name  = "MODE"
          value = "sqs"
        }
      ],
      environmentFiles = [
        {
          type  = "s3"
          value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "ps aux | grep main | grep -v grep || exit 1"]
        interval    = 10
        timeout     = 5
        startPeriod = 0
        retries     = 3
      }
      stopTimeout = 120
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/slack-metrics-worker-${var.env}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "ap-northeast-1"
        }
      }
      readonlyRootFilesystem = true
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_task_definition" "slack_metrics_batch" {
  family                   = "slack-metrics-batch-${var.env}"
  cpu                      = var.ecs_task_specs.slack_metrics_batch.cpu
  memory                   = var.ecs_task_specs.slack_metrics_batch.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn_slack_metrics
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name         = "batch"
      image        = "${var.ecr_url_slack_metrics}"
      essential    = true
      portMappings = []
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
        },
      ]
      environment = [
        {
          name  = "MODE"
          value = "batch"
        }
      ]
      environmentFiles = [
        {
          type  = "s3"
          value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/slack-metrics-batch-${var.env}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "ap-northeast-1"
        }
      }
      readonlyRootFilesystem = true
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}
