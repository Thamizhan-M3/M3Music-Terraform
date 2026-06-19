resource "aws_lambda_function" "upload_logger" {
  function_name = "${var.project_name}-upload-logger"
  package_type  = "Image"
  image_uri     = var.upload_lambda_image
  role          = aws_iam_role.upload_logger_lambda_role.arn
  timeout       = 60
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      aws_subnet.backend_subnet_a.id,
      aws_subnet.backend_subnet_b.id
    ]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      MONGO_SECRET_NAME = data.aws_secretsmanager_secret.mongodb_credentials.name
      DATABASE_IP       = aws_instance.database_instance.private_ip
      DATABASE_PORT     = var.database_port
      MONGO_DB_NAME     = "m3-music"
      DYNAMODB_TABLE    = aws_dynamodb_table.upload_events.name
      BEDROCK_MODEL     = "amazon.nova-2-lite-v1:0"
    }
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_lambda_event_source_mapping" "upload_events_mapping" {
  event_source_arn                   = aws_sqs_queue.upload_events_queue.arn
  function_name                      = aws_lambda_function.upload_logger.arn
  batch_size                         = 10
  maximum_batching_window_in_seconds = 10
  function_response_types            = ["ReportBatchItemFailures"]
}

resource "aws_lambda_function" "hourly_report" {
  function_name = "${var.project_name}-hourly-report"
  package_type  = "Image"
  image_uri     = var.report_lambda_image
  role          = aws_iam_role.report_lambda_role.arn
  timeout       = 300
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      aws_subnet.backend_subnet_a.id,
      aws_subnet.backend_subnet_b.id
    ]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.upload_events.name
      SNS_TOPIC_ARN  = aws_sns_topic.hourly_upload_report.arn
      DATABASE_IP    = aws_instance.database_instance.private_ip
    }
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_lambda_function" "query_songs" {
  function_name = "${var.project_name}-query-songs"
  package_type  = "Image"
  image_uri     = var.upload_lambda_image
  role          = aws_iam_role.query_songs_lambda_role.arn
  timeout       = 60
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      aws_subnet.backend_subnet_a.id,
      aws_subnet.backend_subnet_b.id
    ]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE       = aws_dynamodb_table.upload_events.name
      MOOD_INDEX_NAME      = "mood-uploadedAt-index"
      GENRE_INDEX_NAME     = "genre-uploadedAt-index"
      UPLOADED_INDEX_NAME  = "uploadedAt-index"
      MAX_RESULTS_PER_CALL = "25"
    }
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}
