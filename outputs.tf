# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
output "id" {
  value       = var.bucket_enabled ? join("", aws_s3_bucket.s3_default.*.id) : (var.website_hosting_bucket ? join("", aws_s3_bucket.s3_website.*.id) : (var.bucket_logging_enabled ? join("", aws_s3_bucket.s3_logging.*.id) : join("", aws_s3_bucket.s3_encryption.*.id)))
  description = "The ID of the s3 bucket."

}

output "arn" {
  value       = var.bucket_enabled ? join("", aws_s3_bucket.s3_default.*.arn) : (var.website_hosting_bucket ? join("", aws_s3_bucket.s3_website.*.arn) : (var.bucket_logging_enabled ? join("", aws_s3_bucket.s3_logging.*.arn) : join("", aws_s3_bucket.s3_encryption.*.arn)))
  description = "The ARN of the s3 bucket."

}

output "bucket_domain_name" {
  value       = var.bucket_enabled ? join("", aws_s3_bucket.s3_default.*.bucket_domain_name) : (var.website_hosting_bucket ? join("", aws_s3_bucket.s3_website.*.bucket_domain_name) : (var.bucket_logging_enabled ? join("", aws_s3_bucket.s3_logging.*.bucket_domain_name) : join("", aws_s3_bucket.s3_encryption.*.bucket_domain_name)))
  description = "The Domain of the s3 bucket."

}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}