data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name

  depends_on = [aws_eks_cluster.main]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.main.name,
      "--region",
      var.aws_region
    ]
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        aws_eks_cluster.main.name,
        "--region",
        var.aws_region
      ]
    }
  }
}

resource "helm_release" "m3music" {
  count            = fileexists("${path.module}/M3Music-Helm/Chart.yaml") ? 1 : 0
  name             = "dev-m3"
  namespace        = "default"
  create_namespace = true

  chart = "${path.module}/M3Music-Helm"

  depends_on = [
    aws_eks_node_group.main
  ]
}
