# Static Website on AWS with Terraform

## Project Overview

This project sets up a static website hosted on AWS, utilizing Terraform for infrastructure provisioning and management. The website is hosted on an Amazon S3 bucket, and a CloudFront distribution is used to deliver the content. The setup includes logging, versioning, lifecycle policies, server-side encryption, and a website configuration for the S3 bucket. This infrastructure follows a best-practice approach to securely and efficiently host a static website.

## Project Components

### S3 Bucket for Static Website
   - The project creates two S3 buckets: one for the website's static content and another for logs.
   - The bucket for the website has lifecycle rules to transition objects to a lower-cost storage class and eventually expire them.
   - The website bucket also has versioning enabled and server-side encryption configured with AES256.
   - Logging is configured to direct logs to the logging bucket.
   - The bucket is configured for website hosting with an index document (`index.html`).

### CloudFront Distribution
   - The CloudFront distribution is set up to serve content from the S3 bucket.
   - The CloudFront origin access identity is used to restrict access to the S3 bucket, ensuring that only CloudFront can access it.
   - The distribution includes settings for caching behavior, viewer protocol policy, and geographical restrictions.

### Bucket Policy
   - The S3 bucket policy grants public read access to the website content, while restricting other actions.

### Automating Uploads
   - The project automates the upload of website files to the S3 bucket, ensuring that content is always up to date.

### Provider Configuration
   - The project uses the AWS provider, with the region specified as a variable.

## How to Deploy

1. **Prerequisites**
   - Ensure you have AWS credentials configured on your system.
   - Install Terraform on your system.

2. **Clone the Repository**
   - Clone the project repository to your local machine.

3. **Configure Variables**
   - Set the required variables, including `aws_region`, `bucket_name`, and `tags`.

4. **Deploy the Infrastructure**
   - Initialize the Terraform configuration with `terraform init`.
   - Plan the infrastructure changes with `terraform plan`.
   - Apply the infrastructure with `terraform apply`.

5. **Access the Website**
   - Once the CloudFront distribution is deployed, obtain its domain name from the Terraform output or AWS Console.
   - Access the website by navigating to the CloudFront domain name in a web browser.

## How to Access the Static Website

The static website is delivered through a CloudFront distribution, which serves the content from the S3 bucket. After deploying the infrastructure:

1. Retrieve the CloudFront distribution domain name.
2. Open a web browser and enter the domain name to view the static website.

The CloudFront distribution's caching settings, viewer protocol policy, and other configurations ensure efficient and secure delivery of the website's static content.

## License


