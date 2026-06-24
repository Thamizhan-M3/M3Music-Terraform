resource "aws_lambda_function" "upload_logger" {
  function_name = "${var.project_name}-upload-logger"
  package_type  = "Image"
  image_uri     = var.upload_lambda_image
  role          = module.iam.upload_logger_lambda_role_arn
  timeout       = 60
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      module.vpc.backend_subnet_ids[0],
      module.vpc.backend_subnet_ids[1]
    ]
    security_group_ids = [module.vpc.lambda_sg_id]
  }

  environment {
    variables = {
      MONGO_SECRET_NAME = data.aws_secretsmanager_secret.mongodb_credentials.name
      DATABASE_IP       = aws_instance.database_instance.private_ip
      DATABASE_PORT     = var.database_port
      MONGO_DB_NAME     = "m3-music"
      DYNAMODB_TABLE    = module.database.upload_events_name
      BEDROCK_MODEL     = "amazon.nova-2-lite-v1:0"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-upload-logger"
  })

  depends_on = [module.vpc]
}

resource "aws_lambda_event_source_mapping" "upload_events_mapping" {
  event_source_arn                   = module.messaging.upload_events_queue_arn
  function_name                      = aws_lambda_function.upload_logger.arn
  batch_size                         = 10
  maximum_batching_window_in_seconds = 10
  function_response_types            = ["ReportBatchItemFailures"]
}

resource "aws_lambda_function" "hourly_report" {
  function_name = "${var.project_name}-hourly-report"
  package_type  = "Image"
  image_uri     = var.report_lambda_image
  role          = module.iam.report_lambda_role_arn
  timeout       = 300
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      module.vpc.backend_subnet_ids[0],
      module.vpc.backend_subnet_ids[1]
    ]
    security_group_ids = [module.vpc.lambda_sg_id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE = module.database.upload_events_name
      SNS_TOPIC_ARN  = module.messaging.hourly_upload_report_topic_arn
      DATABASE_IP    = aws_instance.database_instance.private_ip
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-hourly-report"
  })

  depends_on = [module.vpc]
}

resource "aws_lambda_function" "query_songs" {
  function_name = "${var.project_name}-query-songs"
  package_type  = "Image"
  image_uri     = var.upload_lambda_image
  role          = module.iam.query_songs_lambda_role_arn
  timeout       = 60
  memory_size   = 512

  vpc_config {
    subnet_ids = [
      module.vpc.backend_subnet_ids[0],
      module.vpc.backend_subnet_ids[1]
    ]
    security_group_ids = [module.vpc.lambda_sg_id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE       = module.database.upload_events_name
      MOOD_INDEX_NAME      = "mood-uploadedAt-index"
      GENRE_INDEX_NAME     = "genre-uploadedAt-index"
      UPLOADED_INDEX_NAME  = "uploadedAt-index"
      MAX_RESULTS_PER_CALL = "25"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-query-songs"
  })

  depends_on = [module.vpc]
}
