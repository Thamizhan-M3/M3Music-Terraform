output "upload_events_queue_arn" {
  value = aws_sqs_queue.upload_events_queue.arn
}

output "upload_events_queue_url" {
  value = aws_sqs_queue.upload_events_queue.id
}

output "upload_events_from_s3_policy_id" {
  value = aws_sqs_queue_policy.upload_events_from_s3.id
}

output "hourly_upload_report_topic_arn" {
  value = aws_sns_topic.hourly_upload_report.arn
}
