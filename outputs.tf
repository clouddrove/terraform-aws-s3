# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
output "id" {
  value       = try(aws_s3_bucket.s3_default[0].id, null)
  description = "The ID of the s3 bucket."
}

output "arn" {
  value       = try(aws_s3_bucket.s3_default[0].arn, null)
  description = "The ARN of the s3 bucket."
}

output "bucket_domain_name" {
  value       = try(aws_s3_bucket.s3_default[0].bucket_domain_name, null)
  description = "The Domain of the s3 bucket."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}

output "s3_bucket_policy" {
  value       = try(aws_s3_bucket_policy.s3_default[0].policy, null)
  description = "The combined bucket policy, including the HTTPS-only statement when enabled."
}

output "s3_bucket_hosted_zone_id" {
  value       = try(aws_s3_bucket.s3_default[0].hosted_zone_id, null)
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}

output "bucket_regional_domain_name" {
  value       = try(aws_s3_bucket.s3_default[0].bucket_regional_domain_name, null)
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}

output "s3_bucket_lifecycle_configuration_rules" {
  value       = try(aws_s3_bucket_lifecycle_configuration.default[0].rule, null)
  description = "The lifecycle rules of the bucket, or null when lifecycle configuration is disabled."
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint, or null when website hosting is not configured."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, null)
}

output "s3_bucket_website_domain" {
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, null)
  description = "The website endpoint domain, or null when website hosting is not configured."
}

output "notification_configuration_id" {
  value       = try(aws_s3_bucket_notification.this[0].id, null)
  description = "The bucket notification configuration ID, or null when notifications are not configured."
}

output "metadata_configuration" {
  value       = try(aws_s3_bucket_metadata_configuration.this[0].metadata_configuration, null)
  description = "The S3 Metadata configuration, including generated journal and inventory table details."
}

output "abac_status" {
  value       = try(aws_s3_bucket_abac.this[0].abac_status[0].status, null)
  description = "The configured bucket ABAC status, or null when ABAC is unmanaged."
}
