# Terraform Block
terraform {
  required_version = ">= 1.3.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
}



# S3 Bucket for Logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}-logs"
}

# S3 Bucket for the static website
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    id = "log"

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }
}


resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse_config" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_config" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
}


## Automating Uploads with Terraform
resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("${path.module}/website", "**/*")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = each.value
  source   = "${path.module}/website/${each.value}"
  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg",
    gif  = "image/gif",
    svg  = "image/svg+xml",
    ttf  = "font/ttf",
    otf  = "font/otf",
    woff = "font/woff",
    eot  = "application/vnd.ms-fontobject",
    less = "text/css",
    scss = "text/x-scss"
  }, lower(split(".", each.value)[1]), "application/octet-stream")
}


# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "OAI for ${var.bucket_name}"

}

# CloudFront distribution for the S3 bucket
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_oai.cloudfront_access_identity_path
    }
    
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [] # No custom domain aliases are specified

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "MyCloudFrontDistribution"
  }
}


