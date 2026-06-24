variable "aws_region" {
  type = string
}

variable "availability_zone_a" {
  type = string
}

variable "availability_zone_b" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "bastionhost_subnet_a_cidr" {
  type = string
}

variable "bastionhost_subnet_b_cidr" {
  type = string
}

variable "frontend_subnet_a_cidr" {
  type = string
}

variable "frontend_subnet_b_cidr" {
  type = string
}

variable "backend_subnet_a_cidr" {
  type = string
}

variable "backend_subnet_b_cidr" {
  type = string
}

variable "database_subnet_a_cidr" {
  type = string
}

variable "database_subnet_b_cidr" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "backend_port" {
  type = number
}

variable "database_port" {
  type = number
}

variable "common_tags" {
  type = map(string)
}
