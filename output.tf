output "s3_id" {
  description = "The ID of the s3 bucket"
  value       = "${join(" ", aws_s3_bucket.s3.*.id)}"
}
