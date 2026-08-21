output "aws_s3files_file_system_arn" {
  description = "ARN of the file system"
  value       = module.s3_bucket.aws_s3files_file_system_arn
}

output "aws_s3files_file_system_id" {
  description = "Identifier of the file system"
  value       = module.s3_bucket.aws_s3files_file_system_id
}

output "aws_s3files_file_system_name" {
  description = "File system name"
  value       = module.s3_bucket.aws_s3files_file_system_name
}

output "aws_s3files_file_system_owner_id" {
  description = "AWS account ID of the owner"
  value       = module.s3_bucket.aws_s3files_file_system_owner_id
}

output "aws_s3files_file_system_status" {
  description = "File system status"
  value       = module.s3_bucket.aws_s3files_file_system_status
}

output "aws_s3files_file_system_status_message" {
  description = "Status message"
  value       = module.s3_bucket.aws_s3files_file_system_status_message
}

output "aws_s3files_file_system_creation_time" {
  description = "Creation time"
  value       = module.s3_bucket.aws_s3files_file_system_creation_time
}

output "aws_s3files_file_system_tags_all" {
  description = "All tags including provider-inherited ones"
  value       = module.s3_bucket.aws_s3files_file_system_tags_all
}

# ====================

output "aws_s3files_access_point_arn" {
  description = "ARN of the access point"
  value       = module.s3_bucket.aws_s3files_access_point_arn
}

output "aws_s3files_access_point_id" {
  description = "Identifier of the access point"
  value       = module.s3_bucket.aws_s3files_access_point_id
}

output "aws_s3files_access_point_name" {
  description = "Access point name"
  value       = module.s3_bucket.aws_s3files_access_point_name
}

output "aws_s3files_access_point_owner_id" {
  description = "AWS account ID of the owner"
  value       = module.s3_bucket.aws_s3files_access_point_owner_id
}

output "aws_s3files_access_point_status" {
  description = "Access point status"
  value       = module.s3_bucket.aws_s3files_access_point_status
}

output "aws_s3files_access_point_tags_all" {
  description = "All tags including inherited ones"
  value       = module.s3_bucket.aws_s3files_access_point_tags_all
}

# ====================

output "aws_s3files_mount_target_ids" {
  description = "List of mount target IDs"
  value       = module.s3_bucket.aws_s3files_mount_target_ids
}

output "aws_s3files_mount_target_network_interface_ids" {
  description = "List of network interface IDs"
  value       = module.s3_bucket.aws_s3files_mount_target_network_interface_ids
}

output "aws_s3files_mount_target_statuses" {
  description = "List of mount target statuses"
  value       = module.s3_bucket.aws_s3files_mount_target_statuses
}

output "aws_s3files_mount_target_vpc_ids" {
  description = "List of VPC IDs"
  value       = module.s3_bucket.aws_s3files_mount_target_vpc_ids
}

# ====================

output "latest_version_number" {
  description = "Latest sync configuration version number"
  value       = module.s3_bucket.latest_version_number
}
