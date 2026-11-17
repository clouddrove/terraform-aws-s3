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

output "aws_s3files_file_system_arn" {
  description = "ARN of the file system"
  value       = try(aws_s3files_file_system.this[0].arn, null)
}

output "aws_s3files_file_system_id" {
  description = "Identifier of the file system"
  value       = try(aws_s3files_file_system.this[0].id, null)
}

output "aws_s3files_file_system_name" {
  description = "File system name"
  value       = try(aws_s3files_file_system.this[0].name, null)
}

output "aws_s3files_file_system_owner_id" {
  description = "AWS account ID of the owner"
  value       = try(aws_s3files_file_system.this[0].owner_id, null)
}

output "aws_s3files_file_system_status" {
  description = "File system status"
  value       = try(aws_s3files_file_system.this[0].status, null)
}

output "aws_s3files_file_system_status_message" {
  description = "Status message"
  value       = try(aws_s3files_file_system.this[0].status_message, null)
}

output "aws_s3files_file_system_creation_time" {
  description = "Creation time"
  value       = try(aws_s3files_file_system.this[0].creation_time, null)
}

output "aws_s3files_file_system_tags_all" {
  description = "All tags including provider-inherited ones"
  value       = try(aws_s3files_file_system.this[0].tags_all, null)
}

# ====================

output "aws_s3files_access_point_arn" {
  description = "ARN of the access point"
  value       = try(aws_s3files_access_point.this[0].arn, null)
}

output "aws_s3files_access_point_id" {
  description = "Identifier of the access point"
  value       = try(aws_s3files_access_point.this[0].id, null)
}

output "aws_s3files_access_point_name" {
  description = "Access point name"
  value       = try(aws_s3files_access_point.this[0].name, null)
}

output "aws_s3files_access_point_owner_id" {
  description = "AWS account ID of the owner"
  value       = try(aws_s3files_access_point.this[0].owner_id, null)
}

output "aws_s3files_access_point_status" {
  description = "Access point status"
  value       = try(aws_s3files_access_point.this[0].status, null)
}

output "aws_s3files_access_point_tags_all" {
  description = "All tags including inherited ones"
  value       = try(aws_s3files_access_point.this[0].tags_all, null)
}

# ====================

output "aws_s3files_mount_target_ids" {
  description = "List of mount target IDs"
  value       = try([for mt in aws_s3files_mount_target.this : mt.id], [])
}

output "aws_s3files_mount_target_network_interface_ids" {
  description = "List of network interface IDs"
  value       = try([for mt in aws_s3files_mount_target.this : mt.network_interface_id], [])
}

output "aws_s3files_mount_target_statuses" {
  description = "List of mount target statuses"
  value       = try([for mt in aws_s3files_mount_target.this : mt.status], [])
}

output "aws_s3files_mount_target_vpc_ids" {
  description = "List of VPC IDs"
  value       = try([for mt in aws_s3files_mount_target.this : mt.vpc_id], [])
}

# ====================

output "latest_version_number" {
  description = "Latest sync configuration version number"
  value       = try(aws_s3files_synchronization_configuration.this[0].latest_version_number, null)
}
