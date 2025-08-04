variable "env" {
  type = string
}

variable "subnet_group_name" {
  type = string
}

variable "identifier" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "parameter_group_name" {
  type = string
}

variable "family" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}
