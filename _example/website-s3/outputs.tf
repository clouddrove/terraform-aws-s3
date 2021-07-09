output "id" {
  value       = module.s3_bucket.*.id
  description = "The ID of the s3 bucket."
}

output "tags" {
  value       = module.s3_bucket.tags
  description = "A mapping of tags to assign to the S3."
}