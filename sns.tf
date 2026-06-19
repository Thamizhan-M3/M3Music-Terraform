resource "aws_sns_topic" "hourly_upload_report" {
  name = "${var.project_name}-hourly-upload-report"
}

resource "aws_sns_topic_subscription" "admin_email" {
  topic_arn = aws_sns_topic.hourly_upload_report.arn
  protocol  = "email"
  endpoint  = var.admin_email
}

resource "aws_sns_topic" "upload_reports" {
  name = "${var.project_name}-upload-reports"
}