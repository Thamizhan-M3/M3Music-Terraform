variable "project_name" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "cluster_subnet_ids" {
  type = list(string)
}

variable "node_subnet_ids" {
  type = list(string)
}

variable "database_sg_id" {
  type = string
}

variable "database_port" {
  type = number
}

variable "github_actions_principal_arn" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
