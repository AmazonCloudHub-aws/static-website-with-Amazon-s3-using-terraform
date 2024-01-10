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