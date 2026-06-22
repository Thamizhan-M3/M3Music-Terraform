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

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
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

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "frontend_url" {
  type        = string
  description = "Public URL allowed by the backend for frontend-origin requests."
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

variable "songs_bucket_name" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "upload_lambda_image" {
  type = string
}

variable "report_lambda_image" {
  type = string
}
