resource "aws_dynamodb_table" "upload_events" {
  name         = "${var.project_name}-upload-events"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "songId"
  range_key = "uploadedAt"

  attribute {
    name = "songId"
    type = "S"
  }

  attribute {
    name = "uploadedAt"
    type = "S"
  }

  attribute {
    name = "mood"
    type = "S"
  }

  attribute {
    name = "genre"
    type = "S"
  }

  global_secondary_index {
    name            = "mood-uploadedAt-index"
    hash_key        = "mood"
    range_key       = "uploadedAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "genre-uploadedAt-index"
    hash_key        = "genre"
    range_key       = "uploadedAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "uploadedAt-index"
    hash_key        = "uploadedAt"
    projection_type = "ALL"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-upload-events"
  })
}
