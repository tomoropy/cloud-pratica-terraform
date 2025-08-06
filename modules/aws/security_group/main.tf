locals {
  default_egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Allow all outbound traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
}

resource "aws_security_group" "db_migrator" {
  vpc_id  = var.vpc_id
  name    = "cp-db-migrator-${var.env}"
  ingress = []
  egress  = local.default_egress
  tags = {
    Name = "cp-db-migrator-${var.env}"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id      = var.vpc_id
  description = "cp-bastion-${var.env}"
  name        = "cp-bastion-${var.env}"
  ingress     = []
  egress      = local.default_egress
  tags = {
    Name = "cp-bastion-${var.env}"
  }
}

resource "aws_security_group" "nat" {
  vpc_id      = var.vpc_id
  description = "cp-nat-${var.env}"
  name        = "cp-nat-${var.env}"
  ingress = [
    {
      cidr_blocks      = var.private_subnet_cidr_blocks
      description      = "Allow all inbound traffic from private subnet"
      from_port        = 0
      protocol         = "-1"
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = local.default_egress
  tags = {
    Name = "cp-nat-${var.env}"
  }
}

resource "aws_security_group" "alb" {
  vpc_id      = var.vpc_id
  description = "cp-alb-${var.env}"
  name        = "cp-alb-${var.env}"
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow all inbound traffic from internet"
      from_port        = 443
      protocol         = "tcp"
      to_port          = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = local.default_egress
  tags = {
    Name = "cp-alb-${var.env}"
  }
}

resource "aws_security_group" "slack_metrics_backend" {
  vpc_id      = var.vpc_id
  description = "cp-slack-metrics-backend-${var.env}"
  name        = "cp-slack-metrics-backend-${var.env}"
  ingress = [
    {
      cidr_blocks      = []
      description      = "Allow inbound traffic from alb"
      from_port        = 8080
      protocol         = "tcp"
      to_port          = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups = [
        aws_security_group.alb.id
      ]
      self = false
    }
  ]
  egress = local.default_egress
  tags = {
    Name = "cp-slack-metrics-backend-${var.env}"
  }
}

resource "aws_security_group" "db" {
  vpc_id      = var.vpc_id
  description = "DB security group"
  name        = "cp-db-${var.env}"
  ingress = [
    {
      cidr_blocks      = []
      description      = "Allow inbound traffic from services"
      from_port        = 5432
      protocol         = "tcp"
      to_port          = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups = concat([
        aws_security_group.db_migrator.id,
        aws_security_group.bastion.id,
        aws_security_group.slack_metrics_backend.id
      ])
      self = false
    }
  ]
  egress = local.default_egress
  tags = {
    Name = "cp-db-${var.env}"
  }
}
