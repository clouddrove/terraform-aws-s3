output "bucket_id" {
  value       = try(module.s3_lifecycle.id, null)
  description = "The name (ID) of the created S3 bucket."
}

output "bucket_arn" {
  value       = try(module.s3_lifecycle.arn, null)
  description = "The ARN of the created S3 bucket."
}

output "bucket_domain_name" {
  value       = try(module.s3_lifecycle.bucket_domain_name, null)
  description = "The bucket domain name."
}

output "tags" {
  value       = try(module.s3_lifecycle.tags, null)
  description = "The tags applied to the S3 bucket."
}
