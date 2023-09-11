# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
output "id" {
  value       = join("", aws_s3_bucket.s3_default[*].id)
  description = "The ID of the s3 bucket."
}

output "arn" {
  value       = join("", aws_s3_bucket.s3_default[*].arn)
  description = "The ARN of the s3 bucket."
}

output "bucket_domain_name" {
  value       = join("", aws_s3_bucket.s3_default[*].bucket_domain_name)
  description = "The Domain of the s3 bucket."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}

output "s3_bucket_policy" {
  value       = try(aws_s3_bucket_policy.s3_default[0].policy, "")
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
}

output "s3_bucket_hosted_zone_id" {
  value       = try(aws_s3_bucket.s3_default[0].hosted_zone_id, "")
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}

output "bucket_regional_domain_name" {
  value       = try(aws_s3_bucket.s3_default[0].bucket_regional_domain_name, "")
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}

output "s3_bucket_lifecycle_configuration_rules" {
  value       = try(aws_s3_bucket_lifecycle_configuration.default[0].rule, "")
  description = "The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string."
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, "")
}

output "s3_bucket_website_domain" {
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, "")
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records."
}
