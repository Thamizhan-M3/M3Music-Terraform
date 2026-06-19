resource "aws_kms_key" "songs_kms" {
  description             = "KMS key for songs bucket"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "songs_kms_alias" {
  name          = "alias/${var.project_name}-songs-key"
  target_key_id = aws_kms_key.songs_kms.key_id
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key_policy" "songs_kms_policy" {
  key_id = aws_kms_key.songs_kms.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "EnableRootPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "AllowBackendRoleUsage",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.backend_role.arn
        },
        Action = [
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowS3ToUseKeyForS3Objects",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:SourceArn" = aws_s3_bucket.songs_bucket.arn
          }
        }
      },
      {
        Sid    = "AllowS3UseOfKeyViaCloudFront",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:SourceArn"     = aws_s3_bucket.songs_bucket.arn,
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AllowCloudFrontUseOfKMSKey",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.songs_cdn.arn
          }
        }
      }
    ]
  })
}