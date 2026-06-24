module "vpc" {
  source                    = "./modules/vpc"
  aws_region                = var.aws_region
  availability_zone_a       = var.availability_zone_a
  availability_zone_b       = var.availability_zone_b
  project_name              = var.project_name
  vpc_cidr                  = var.vpc_cidr
  bastionhost_subnet_a_cidr = var.bastionhost_subnet_a_cidr
  bastionhost_subnet_b_cidr = var.bastionhost_subnet_b_cidr
  frontend_subnet_a_cidr    = var.frontend_subnet_a_cidr
  frontend_subnet_b_cidr    = var.frontend_subnet_b_cidr
  backend_subnet_a_cidr     = var.backend_subnet_a_cidr
  backend_subnet_b_cidr     = var.backend_subnet_b_cidr
  database_subnet_a_cidr    = var.database_subnet_a_cidr
  database_subnet_b_cidr    = var.database_subnet_b_cidr
  frontend_port             = var.frontend_port
  backend_port              = var.backend_port
  database_port             = var.database_port
  common_tags               = local.common_tags
}

module "eks" {
  source                       = "./modules/eks"
  project_name                 = var.project_name
  desired_capacity             = var.desired_capacity
  min_size                     = var.min_size
  max_size                     = var.max_size
  cluster_subnet_ids           = concat(module.vpc.frontend_subnet_ids, module.vpc.backend_subnet_ids)
  node_subnet_ids              = module.vpc.backend_subnet_ids
  database_sg_id               = module.vpc.database_sg_id
  database_port                = var.database_port
  github_actions_principal_arn = "arn:aws:iam::115717304992:role/github-actions-terraform-role"
  common_tags                  = local.common_tags
}

module "iam" {
  source                  = "./modules/iam"
  aws_region              = var.aws_region
  project_name            = var.project_name
  oidc_provider_arn       = module.eks.oidc_provider_arn
  oidc_provider_url       = module.eks.oidc_provider_url
  songs_bucket_arn        = aws_s3_bucket.songs_bucket.arn
  songs_kms_key_arn       = aws_kms_key.songs_kms.arn
  mongodb_secret_arn      = data.aws_secretsmanager_secret.mongodb_credentials.arn
  jwt_secret_arn          = data.aws_secretsmanager_secret.jwt_secret.arn
  upload_events_queue_arn = module.messaging.upload_events_queue_arn
  upload_events_table_arn = module.database.upload_events_arn
  hourly_report_topic_arn = module.messaging.hourly_upload_report_topic_arn
  common_tags             = local.common_tags
}

module "database" {
  source       = "./modules/database"
  project_name = var.project_name
  common_tags  = local.common_tags
}

module "messaging" {
  source            = "./modules/messaging"
  project_name      = var.project_name
  admin_email       = var.admin_email
  songs_bucket_arn  = aws_s3_bucket.songs_bucket.arn
  caller_account_id = data.aws_caller_identity.current.account_id
  common_tags       = local.common_tags
}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
  common_tags  = local.common_tags
}

module "monitoring" {
  source            = "./modules/monitoring"
  enable_monitoring = var.enable_monitoring

  depends_on = [
    module.eks
  ]
}

module "gitops" {
  source = "./modules/gitops"

  depends_on = [
    module.eks
  ]
}
