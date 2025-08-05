resource "aws_ecs_cluster" "cloud_pratica_backend" {
  name = "cloud-pratica-backend-${var.env}"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cloud_pratica_backend" {
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  cluster_name       = aws_ecs_cluster.cloud_pratica_backend.name
}
