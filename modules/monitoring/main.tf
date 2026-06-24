resource "helm_release" "kube_prometheus_stack" {
  count            = var.enable_monitoring ? 1 : 0
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.9.0"

  timeout = 1200
  wait    = true

  values = [
    yamlencode({
      admissionWebhooks = {
        enabled = false
      }

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
        enabled = true

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
          type = "LoadBalancer"
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
}