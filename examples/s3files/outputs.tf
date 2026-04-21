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