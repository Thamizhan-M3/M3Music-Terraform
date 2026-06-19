resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/${var.project_name}/backend"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/${var.project_name}/frontend"
  retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "hourly_upload_report" {
  name                = "${var.project_name}-hourly-upload-report"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "hourly_upload_report" {
  rule = aws_cloudwatch_event_rule.hourly_upload_report.name
  arn  = aws_lambda_function.hourly_report.arn
}