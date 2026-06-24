variable "project_name" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "songs_bucket_arn" {
  type = string
}

variable "caller_account_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
