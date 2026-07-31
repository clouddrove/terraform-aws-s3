variable "kms_key_arn" {
  description = "ARN of an existing customer-managed KMS key used for S3 and S3Files encryption."
  type        = string
  nullable    = false
}