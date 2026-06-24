resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name = "${var.project_name}-bedrock-agent-policy"
  role = module.iam.bedrock_agent_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction"]
        Resource = aws_lambda_function.query_songs.arn
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = local.bedrock_nova_model_arn
      }
    ]
  })
}
