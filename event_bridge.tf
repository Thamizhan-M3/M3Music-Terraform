resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hourly_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.hourly_upload_report.arn
}

resource "aws_s3_bucket_notification" "songs_upload_notification" {
  bucket = aws_s3_bucket.songs_bucket.id

  queue {
    queue_arn = aws_sqs_queue.upload_events_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.upload_events_from_s3]
}

resource "aws_lambda_permission" "allow_bedrock_query" {
  statement_id  = "AllowBedrockInvokeQuery"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.query_songs.function_name
  principal     = "bedrock.amazonaws.com"
  source_arn    = aws_bedrockagent_agent.music_agent.agent_arn
}
