output "cloudfront_domain" {
  value = aws_cloudfront_distribution.songs_cdn.domain_name
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "database_private_ip" {
  value = aws_instance.database_instance.private_ip
}

output "upload_events_table" {
  value = aws_dynamodb_table.upload_events.name
}

output "hourly_report_topic_arn" {
  value = aws_sns_topic.hourly_upload_report.arn
}
