provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      var.aws_region
    ]
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        var.aws_region
      ]
    }
  }
}

locals {
  backend_image_tag        = element(reverse(split(":", var.backend_image)), 0)
  backend_image_repository = trimsuffix(var.backend_image, ":${local.backend_image_tag}")

  frontend_image_tag        = element(reverse(split(":", var.frontend_image)), 0)
  frontend_image_repository = trimsuffix(var.frontend_image, ":${local.frontend_image_tag}")

  mongodb_secret       = try(jsondecode(data.aws_secretsmanager_secret_version.mongodb_credentials.secret_string), {})
  mongodb_uri_override = try(trimspace(lookup(local.mongodb_secret, "MONGODB_URI", "")), "")
  mongodb_username     = try(trimspace(lookup(local.mongodb_secret, "MONGO_USERNAME", "")), "")
  mongodb_password     = try(trimspace(lookup(local.mongodb_secret, "MONGO_PASSWORD", "")), "")
  mongodb_uri = local.mongodb_uri_override != "" ? local.mongodb_uri_override : format(
    "mongodb://%s:%s@%s:%s/m3-music?authSource=admin",
    urlencode(local.mongodb_username),
    urlencode(local.mongodb_password),
    aws_instance.database_instance.private_ip,
    var.database_port
  )

  jwt_secret_json = try(jsondecode(data.aws_secretsmanager_secret_version.jwt_secret.secret_string), {})
  jwt_secret      = try(trimspace(lookup(local.jwt_secret_json, "JWT_SECRET", lookup(local.jwt_secret_json, "jwt_secret", ""))), "") != "" ? try(trimspace(lookup(local.jwt_secret_json, "JWT_SECRET", lookup(local.jwt_secret_json, "jwt_secret", ""))), "") : trimspace(data.aws_secretsmanager_secret_version.jwt_secret.secret_string)
}

resource "helm_release" "m3music" {
  name             = "m3music"
  namespace        = "dev-m3"
  create_namespace = true
  chart            = "https://github.com/Thamizhan-M3/M3Music-Helm/releases/download/v0.1.0/m3-music-0.2.0.tgz"
  # chart   = "../M3Music-Helm"
  timeout = 600
  wait    = true

  set = [
    {
      name  = "backend.image.repository"
      value = local.backend_image_repository
    },
    {
      name  = "backend.image.tag"
      value = local.backend_image_tag
    },
    {
      name  = "backend.replicaCount"
      value = "2"
    },
    {
      name  = "frontend.image.repository"
      value = local.frontend_image_repository
    },
    {
      name  = "frontend.image.tag"
      value = local.frontend_image_tag
    },
    {
      name  = "frontend.replicaCount"
      value = "2"
    },
    {
      name  = "frontend.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "backend.service.type"
      value = "ClusterIP"
    },
    {
      name  = "global.serviceAccount.name"
      value = "m3music-m3-music"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.iam.backend_irsa_role_arn
    },
    {
      name  = "env.PORT"
      value = "10000"
    },
    {
      name  = "env.FRONTEND_URL"
      value = var.frontend_url
    },
    {
      name  = "env.AWS_REGION"
      value = var.aws_region
    },
    {
      name  = "env.S3_BUCKET_NAME"
      value = aws_s3_bucket.songs_bucket.bucket
    },
    {
      name  = "env.S3_PUBLIC_URL"
      value = "https://${aws_cloudfront_distribution.songs_cdn.domain_name}"
    },
    {
      name  = "networkPolicy.backend.database.cidr"
      value = "${aws_instance.database_instance.private_ip}/32"
    },
    {
      name  = "networkPolicy.backend.database.port"
      value = tostring(var.database_port)
    }
  ]

  set_sensitive = [
    {
      name  = "secretEnv.MONGODB_URI"
      value = local.mongodb_uri
    },
    {
      name  = "secretEnv.JWT_SECRET"
      value = local.jwt_secret
    }
  ]

  depends_on = [
    module.eks,
    module.iam
  ]
}
