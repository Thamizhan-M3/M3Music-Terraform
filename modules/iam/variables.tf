variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "songs_bucket_arn" {
  type = string
}

variable "songs_kms_key_arn" {
  type = string
}

variable "mongodb_secret_arn" {
  type = string
}

variable "jwt_secret_arn" {
  type = string
}

variable "upload_events_queue_arn" {
  type = string
}

variable "upload_events_table_arn" {
  type = string
}

variable "hourly_report_topic_arn" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
