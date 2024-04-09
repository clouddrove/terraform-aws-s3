output "id" {
  value       = module.s3_bucket[*].id
  description = "The ID of the s3 bucket."
}

output "tags" {
  value       = module.s3_bucket.tags
  description = "A mapping of tags to assign to the S3."
}

output "s3_bucket_website_endpoint" {
  value       = module.s3_bucket.s3_bucket_website_endpoint
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
}
