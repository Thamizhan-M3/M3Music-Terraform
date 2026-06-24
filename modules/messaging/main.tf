resource "aws_sqs_queue" "upload_events_dlq" {
  name                      = "${var.project_name}-upload-events-dlq"
  message_retention_seconds = 1209600

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-upload-events-dlq"
  })
}

resource "aws_sqs_queue" "upload_events_queue" {
  name                       = "${var.project_name}-upload-events"
  visibility_timeout_seconds = 180
  message_retention_seconds  = 345600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.upload_events_dlq.arn
    maxReceiveCount     = 5
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-upload-events"
  })
}

resource "aws_sqs_queue_policy" "upload_events_from_s3" {
  queue_url = aws_sqs_queue.upload_events_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ObjectCreatedNotifications"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.upload_events_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.songs_bucket_arn
          }
          StringEquals = {
            "aws:SourceAccount" = var.caller_account_id
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic" "hourly_upload_report" {
  name = "${var.project_name}-hourly-upload-report"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-hourly-upload-report"
  })
}

resource "aws_sns_topic_subscription" "admin_email" {
  topic_arn = aws_sns_topic.hourly_upload_report.arn
  protocol  = "email"
  endpoint  = var.admin_email
}

resource "aws_sns_topic" "upload_reports" {
  name = "${var.project_name}-upload-reports"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-upload-reports"
  })
}
