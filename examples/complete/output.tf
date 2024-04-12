output "tags" {
  value       = module.s3_bucket.tags
  description = "A mapping of tags to assign to the S3."
}

output "s3_bucket_id" {
  value       = module.s3_bucket.id
  description = "The name of the bucket."
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "bucket_domain_name" {
  value       = module.s3_bucket.bucket_domain_name
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}