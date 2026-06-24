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

output "m3music_namespace" {
  value = helm_release.m3music.namespace
}

output "m3music_frontend_service_name" {
  value = "m3music-m3-music-frontend"
}

output "m3music_backend_service_name" {
  value = "m3music-m3-music-backend"
}

output "m3music_frontend_service_type" {
  value = "LoadBalancer"
}

output "tradeflow_namespace" {
  value = "tradeflow"
}

output "tradeflow_gateway_service_name" {
  value = "tradeflow-eks-gateway"
}

output "tradeflow_endpoint_lookup_command" {
  value = "kubectl get svc tradeflow-eks-gateway -n tradeflow -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "argocd_server_service_name" {
  value = "argocd-server"
}

output "argocd_endpoint_lookup_command" {
  value = "kubectl get svc argocd-server -n argocd"
}

output "grafana_namespace" {
  value = "disabled"
}

output "grafana_service_name" {
  value = "disabled"
}

output "grafana_endpoint_lookup_command" {
  value = "Grafana is disabled to reduce kube-prometheus-stack pod footprint"
}

output "prometheus_service_name" {
  value = "kube-prometheus-stack-prometheus"
}
