## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.s3_oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | `"eu-central-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket. Must be Unique across AWS | `string` | `"terraform-website-bucket"` | no |
| <a name="input_cf_alias"></a> [cf\_alias](#input\_cf\_alias) | The alias (CNAME) for the CloudFront distribution, such as www.example.com | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "dev",<br>  "Terraform": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the S3 Bucket |
| <a name="output_domain"></a> [domain](#output\_domain) | Domain Name of the bucket |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint Information of the bucket |
| <a name="output_name"></a> [name](#output\_name) | Name (id) of the bucket |
Damilolas-Air:static-website-with-Amazon-s3-using-terraform damilolaijato$ terraform-docs markdown table .
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.s3_oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | `"eu-central-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket. Must be Unique across AWS | `string` | `"terraform-website-bucket"` | no |
| <a name="input_cf_alias"></a> [cf\_alias](#input\_cf\_alias) | The alias (CNAME) for the CloudFront distribution, such as www.example.com | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "dev",<br>  "Terraform": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the S3 Bucket |
| <a name="output_domain"></a> [domain](#output\_domain) | Domain Name of the bucket |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint Information of the bucket |
| <a name="output_name"></a> [name](#output\_name) | Name (id) of the bucket |

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

