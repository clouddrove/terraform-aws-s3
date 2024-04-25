output "id" {
  value       = module.s3_bucket[*].id
  description = "The ID of the s3 bucket."
}

output "tags" {
  value       = module.s3_bucket.tags
  description = "A mapping of tags to assign to the S3."
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "s3_bucket_hosted_zone_id" {
  value       = module.s3_bucket.s3_bucket_hosted_zone_id
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}