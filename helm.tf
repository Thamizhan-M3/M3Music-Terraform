provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)

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
    token                  = data.aws_eks_cluster_auth.main.token
  }
}

data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

resource "helm_release" "m3music" {
  name             = "m3music"
  namespace        = "dev-m3"
  create_namespace = true
  chart = "${path.module}/../M3Music-Helm"

  set = [
    {
      name  = "backend.image.repository"
      value = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/m3music-backend"
    },
    {
      name  = "backend.image.tag"
      value = "v1"
    },
    {
      name  = "frontend.image.repository"
      value = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/m3music-frontend"
    },
    {
      name  = "frontend.image.tag"
      value = "v1"
    }
  ]

  depends_on = [
    aws_eks_node_group.main
  ]
}
