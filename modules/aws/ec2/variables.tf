variable "env" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "bastion" {
  type = object({
    # デフォルト値は、Amazon Linux 2023 の AMI ID
    ami_id               = optional(string, "ami-0f95ad36d6d54ceba")
    instance_type        = optional(string, "t2.micro")
    iam_instance_profile = string
    security_group_id    = string
  })
}

variable "nat_1a" {
  type = object({
    # デフォルト値は、Amazon Linux 2023 の AMI ID
    ami_id               = optional(string, "ami-0f95ad36d6d54ceba")
    instance_type        = optional(string, "t2.micro")
    iam_instance_profile = string
    security_group_id    = string
  })
}
