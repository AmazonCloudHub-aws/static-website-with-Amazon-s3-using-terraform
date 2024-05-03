/*
# AWS S3 and CloudFront Terraform Configuration

This Terraform configuration sets up an AWS S3 bucket and a CloudFront distribution. The S3 bucket is configured for hosting a static website with enhanced security and management features. The CloudFront distribution is used to deliver content from the S3 bucket efficiently.

## Components

- **S3 Bucket**: Configured for website hosting with public read access, versioning, server-side encryption, access logging, lifecycle rules, and a policy for CloudFront access.
- **S3 Bucket for Logs**: A separate bucket for storing access logs from the primary S3 bucket.
- **CloudFront Distribution**: Setup to serve content from the S3 bucket globally with optimized performance and caching.
- **CloudFront Origin Access Identity (OAI)**: Used to restrict direct access to the S3 bucket, allowing only CloudFront to access it.

## Features

1. **S3 Bucket Configuration**:
   - Versioning: Enabled to keep multiple versions of an object in the same bucket.
   - Server-Side Encryption: Uses AES256 encryption algorithm for data security.
   - Access Logging: Logs stored in a separate S3 bucket for monitoring and auditing.
   - Lifecycle Rules: Automates transitioning of older objects to cheaper storage classes and clean-up.
   - Bucket Policy: Restricts access to the bucket to only the CloudFront distribution.

2. **CloudFront Distribution Configuration**:
   - Caching: Optimizes the delivery of website content.
   - Security: Uses the default CloudFront SSL certificate for HTTPS connections.
   - IPv6 Enabled: Allows access via IPv6 addresses.
   - Default Root Object: Set to 'index.html'.

## Usage

Before running this configuration, update the variables in the `variables.tf` file, especially the AWS region (`aws_region`), S3 bucket name (`bucket_name`), and CloudFront alias (`cf_alias`). Ensure that your AWS account has the necessary permissions to create and manage these resources.

Run the following commands to deploy the infrastructure:


## Notes

- Modify the configuration according to your specific requirements.
- Ensure the bucket names are globally unique.
- If using a custom domain with CloudFront, configure an SSL certificate with AWS Certificate Manager.

*/

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

locals {
  # Defining common content types for various file extensions
  content_types = {
    "html"  = "text/html",
    "css"   = "text/css",
    "js"    = "application/javascript",
    "png"   = "image/png",
    "jpg"   = "image/jpeg",
    "jpeg"  = "image/jpeg",
    "less"  = "text/less",
    "default" = "application/octet-stream"
  }
}


# S3 Bucket for Logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}-logs"
  acl    = "log-delivery-write"
}

# Create S3 Bucket Resource
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
    bucket = aws_s3_bucket.s3_bucket.id
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


resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": aws_cloudfront_origin_access_identity.s3_oai.iam_arn
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
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
  acl      = "public-read"
  content_type = lookup(
  local.content_types,
  lower(
    length(split(".", each.value)) > 1 ? split(".", each.value)[length(split(".", each.value)) - 1] : ""
  ),
  local.content_types["default"]
)

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

  aliases = []  # No custom domain aliases are specified

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
}


