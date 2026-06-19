data "aws_secretsmanager_secret" "jwt_secret" {
  name = "${var.project_name}/jwt"
}

data "aws_secretsmanager_secret" "mongodb_credentials" {
  name = "${var.project_name}/mongodb"
}

data "aws_secretsmanager_secret_version" "mongodb_credentials" {
  secret_id = data.aws_secretsmanager_secret.mongodb_credentials.id
}
