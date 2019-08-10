# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
output "id" {
  value = concat(
    aws_s3_bucket.s3_default.*.id,
    aws_s3_bucket.s3_website.*.id,
    aws_s3_bucket.s3_logging.*.id,
    aws_s3_bucket.s3_encryption.*.id
  )[0]
  description = "The ID of the s3 bucket."

}

output "arn" {
  value = concat(
    aws_s3_bucket.s3_default.*.arn,
    aws_s3_bucket.s3_website.*.arn,
    aws_s3_bucket.s3_logging.*.arn,
    aws_s3_bucket.s3_encryption.*.arn
  )[0]
  description = "The ARN of the s3 bucket."

}

output "bucket_domain_name" {
  value = concat(
    aws_s3_bucket.s3_default.*.bucket_domain_name,
    aws_s3_bucket.s3_website.*.bucket_domain_name,
    aws_s3_bucket.s3_logging.*.bucket_domain_name,
    aws_s3_bucket.s3_encryption.*.bucket_domain_name
  )[0]
  description = "The Domain of the s3 bucket."

}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}