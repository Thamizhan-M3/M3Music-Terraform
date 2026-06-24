data "aws_partition" "current" {}

locals {
  bedrock_nova_model_arn = "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/amazon.nova-2-lite-v1:0"

  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = "M3Music"
    ManagedBy   = "Terraform"
  }
}
