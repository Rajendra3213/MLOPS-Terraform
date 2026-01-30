variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
