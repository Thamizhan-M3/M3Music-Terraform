output "cloudfront_domain" {
  value = aws_cloudfront_distribution.songs_cdn.domain_name
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "database_private_ip" {
  value = aws_instance.database_instance.private_ip
}

output "upload_events_table" {
  value = module.database.upload_events_name
}

output "hourly_report_topic_arn" {
  value = module.messaging.hourly_upload_report_topic_arn
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
  value = module.gitops.argocd_namespace
}

output "argocd_server_service_name" {
  value = "argocd-server"
}

output "argocd_endpoint_lookup_command" {
  value = "kubectl get svc argocd-server -n argocd"
}

output "grafana_namespace" {
  value = module.monitoring.monitoring_namespace
}

output "grafana_service_name" {
  value = module.monitoring.grafana_service_name
}

output "grafana_endpoint_lookup_command" {
  value = "kubectl get svc kube-prometheus-stack-grafana -n monitoring"
}

output "prometheus_service_name" {
  value = module.monitoring.prometheus_service_name
}

output "backend_ecr_repository_url" {
  value = module.storage.backend_ecr_repository_url
}

output "frontend_ecr_repository_url" {
  value = module.storage.frontend_ecr_repository_url
}
