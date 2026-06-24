resource "aws_cloudfront_origin_access_control" "songs_oac" {
  name                              = "${var.project_name}-songs-oac"
  description                       = "CloudFront access to songs bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "songs_cdn" {

  enabled = true
  # web_acl_id = aws_wafv2_web_acl.songs_cdn.arn

  origin {
    domain_name              = aws_s3_bucket.songs_bucket.bucket_regional_domain_name
    origin_id                = "songs-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.songs_oac.id
  }

  default_cache_behavior {

    target_origin_id = "songs-s3"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-songs-cdn"
  })
}
