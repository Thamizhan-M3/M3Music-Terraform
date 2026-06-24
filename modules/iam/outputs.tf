output "backend_irsa_role_arn" {
  value = aws_iam_role.backend_irsa_role.arn
}

output "backend_irsa_s3_attachment_id" {
  value = aws_iam_role_policy_attachment.backend_irsa_s3_attachment.id
}

output "backend_irsa_kms_attachment_id" {
  value = aws_iam_role_policy_attachment.backend_irsa_kms_attachment.id
}

output "backend_role_arn" {
  value = aws_iam_role.backend_role.arn
}

output "database_profile_name" {
  value = aws_iam_instance_profile.database_profile.name
}

output "upload_logger_lambda_role_arn" {
  value = aws_iam_role.upload_logger_lambda_role.arn
}

output "report_lambda_role_arn" {
  value = aws_iam_role.report_lambda_role.arn
}

output "query_songs_lambda_role_arn" {
  value = aws_iam_role.query_songs_lambda_role.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.upload_logger_lambda_role.arn
}

output "bedrock_agent_role_arn" {
  value = aws_iam_role.bedrock_agent_role.arn
}

output "bedrock_agent_role_id" {
  value = aws_iam_role.bedrock_agent_role.id
}

output "github_actions_role_arn" {
  value = null
}
