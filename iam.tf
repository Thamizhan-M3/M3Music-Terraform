data "aws_partition" "current" {}

locals {
  bedrock_nova_model_arn = "arn:${data.aws_partition.current.partition}:bedrock:${var.aws_region}::foundation-model/amazon.nova-2-lite-v1:0"
  ecr_repository_arns = [
    "arn:${data.aws_partition.current.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/m3music-frontend",
    "arn:${data.aws_partition.current.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/m3music-backend",
    "arn:${data.aws_partition.current.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/upload-processor",
    "arn:${data.aws_partition.current.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/report-processor"
  ]
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "frontend_role" {
  name               = "${var.project_name}-frontend-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role" "backend_role" {
  name               = "${var.project_name}-backend-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role" "database_role" {
  name               = "${var.project_name}-database-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "frontend_profile" {
  name = "${var.project_name}-frontend-profile"
  role = aws_iam_role.frontend_role.name
}

resource "aws_iam_instance_profile" "backend_profile" {
  name = "${var.project_name}-backend-profile"
  role = aws_iam_role.backend_role.name
}

resource "aws_iam_instance_profile" "database_profile" {
  name = "${var.project_name}-database-profile"
  role = aws_iam_role.database_role.name
}

resource "aws_iam_policy" "s3_upload_policy" {
  name = "${var.project_name}-s3-upload-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.songs_bucket.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.songs_bucket.arn
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name = "${var.project_name}-cloudwatch-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/${var.project_name}/frontend",
          "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/${var.project_name}/frontend:*",
          "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/${var.project_name}/backend",
          "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/${var.project_name}/backend:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name = "${var.project_name}-secrets-manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          data.aws_secretsmanager_secret.mongodb_credentials.arn,
          data.aws_secretsmanager_secret.jwt_secret.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name = "${var.project_name}-ecr-pull-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = local.ecr_repository_arns
      }
    ]
  })
}

resource "aws_iam_policy" "kms_usage_policy" {
  name = "${var.project_name}-kms-usage"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.songs_kms.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_s3_attachment" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend_cloudwatch_attachment" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "frontend_cloudwatch_attachment" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend_secrets_attachment" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend_ecr_attachment" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

resource "aws_iam_role_policy_attachment" "frontend_ecr_attachment" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend_kms_attachment" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.kms_usage_policy.arn
}

resource "aws_iam_role_policy_attachment" "database_secret_attachment" {
  role       = aws_iam_role.database_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_policy" "ssm_core_custom" {
  name = "${var.project_name}-ssm-core-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "frontend_ssm_custom" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = aws_iam_policy.ssm_core_custom.arn
}

resource "aws_iam_role_policy_attachment" "backend_ssm_custom" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.ssm_core_custom.arn
}

resource "aws_iam_role_policy_attachment" "database_ssm_custom" {
  role       = aws_iam_role.database_role.name
  policy_arn = aws_iam_policy.ssm_core_custom.arn
}

resource "aws_iam_role" "upload_logger_lambda_role" {
  name               = "${var.project_name}-upload-logger-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "report_lambda_role" {
  name               = "${var.project_name}-report-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "query_songs_lambda_role" {
  name               = "${var.project_name}-query-songs-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "upload_logger_basic_execution" {
  role       = aws_iam_role.upload_logger_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "upload_logger_vpc_access" {
  role       = aws_iam_role.upload_logger_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "report_basic_execution" {
  role       = aws_iam_role.report_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "report_vpc_access" {
  role       = aws_iam_role.report_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "query_songs_basic_execution" {
  role       = aws_iam_role.query_songs_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "query_songs_vpc_access" {
  role       = aws_iam_role.query_songs_lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "upload_logger_lambda_policy" {
  name = "${var.project_name}-upload-logger-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = aws_sqs_queue.upload_events_queue.arn
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.upload_events.arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = data.aws_secretsmanager_secret.mongodb_credentials.arn
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

resource "aws_iam_policy" "report_lambda_policy" {
  name = "${var.project_name}-report-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.upload_events.arn,
          "${aws_dynamodb_table.upload_events.arn}/index/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.hourly_upload_report.arn
      }
    ]
  })
}

resource "aws_iam_policy" "query_songs_lambda_policy" {
  name = "${var.project_name}-query-songs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.upload_events.arn,
          "${aws_dynamodb_table.upload_events.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "upload_logger_custom_attachment" {
  role       = aws_iam_role.upload_logger_lambda_role.name
  policy_arn = aws_iam_policy.upload_logger_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "report_lambda_attachment" {
  role       = aws_iam_role.report_lambda_role.name
  policy_arn = aws_iam_policy.report_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "query_songs_custom_attachment" {
  role       = aws_iam_role.query_songs_lambda_role.name
  policy_arn = aws_iam_policy.query_songs_lambda_policy.arn
}

resource "aws_iam_role" "bedrock_agent_role" {
  name = "${var.project_name}-bedrock-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name = "${var.project_name}-bedrock-agent-policy"
  role = aws_iam_role.bedrock_agent_role.id

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

data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "${var.project_name}-ebs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.main]
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.main]
}
