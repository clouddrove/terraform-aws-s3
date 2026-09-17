output "bucket_id" {
  description = "The generated S3 bucket name."
  value       = module.s3_bucket.id
}

output "metadata_configuration" {
  description = "The generated S3 Metadata table details."
  value       = module.s3_bucket.metadata_configuration
}
