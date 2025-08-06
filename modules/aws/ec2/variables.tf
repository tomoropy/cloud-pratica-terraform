variable "env" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id_amazon_linux" {
  type    = string
  default = "ami-0f95ad36d6d54ceba" // OS: Amazon Linux
}

variable "bastion_security_group_ids" {
  type = list(string)
}

variable "nat_security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

