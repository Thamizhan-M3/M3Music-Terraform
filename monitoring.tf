resource "helm_release" "kube_prometheus_stack" {
  count            = var.enable_monitoring ? 1 : 0
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.9.0"

  timeout = 600
  wait    = true

  values = [
    yamlencode({
      defaultRules = {
        create = false
      }
      alertmanager = {
        enabled = false
      }
      "prometheus-node-exporter" = {
        enabled = false
      }
      grafana = {
        enabled = false
        resources = {
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
        }
        service = {
          type = "ClusterIP"
          port = 80
        }
      }
      prometheus = {
        prometheusSpec = {
          replicas  = 1
          retention = "6h"
          resources = {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
        service = {
          type = "ClusterIP"
        }
      }
      prometheusOperator = {
        admissionWebhooks = {
          enabled = false
        }
        resources = {
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "200m"
            memory = "256Mi"
          }
        }
      }
      "kube-state-metrics" = {
        enabled = false
        resources = {
          requests = {
            cpu    = "25m"
            memory = "64Mi"
          }
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }
      }
    })
  ]

  depends_on = [
    aws_eks_node_group.main
  ]
}
