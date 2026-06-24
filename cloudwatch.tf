resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/${var.project_name}/backend"
  retention_in_days = 30

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-backend-logs"
  })
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/${var.project_name}/frontend"
  retention_in_days = 30

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-frontend-logs"
  })
}

resource "aws_cloudwatch_event_rule" "hourly_upload_report" {
  name                = "${var.project_name}-hourly-upload-report"
  schedule_expression = "rate(1 hour)"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-hourly-upload-report"
  })
}

resource "aws_cloudwatch_event_target" "hourly_upload_report" {
  rule = aws_cloudwatch_event_rule.hourly_upload_report.name
  arn  = aws_lambda_function.hourly_report.arn
}
