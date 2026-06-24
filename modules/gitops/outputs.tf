output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "argocd_server_service_name" {
  value = "argocd-server"
}
