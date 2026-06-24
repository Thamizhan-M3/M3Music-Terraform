resource "aws_s3_bucket" "songs_bucket" {
  bucket = var.songs_bucket_name

  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-songs"
  })
}

resource "aws_s3_bucket_versioning" "songs_versioning" {
  bucket = aws_s3_bucket.songs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "songs_encryption" {
  bucket = aws_s3_bucket.songs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.songs_kms.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "songs_public_block" {
  bucket = aws_s3_bucket.songs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "songs_policy" {
  bucket = aws_s3_bucket.songs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AlllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.songs_bucket.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn"     = aws_cloudfront_distribution.songs_cdn.arn
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
  depends_on = [aws_cloudfront_distribution.songs_cdn]
}
