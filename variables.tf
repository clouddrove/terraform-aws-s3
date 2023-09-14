#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-s3"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : S3 BUCKET
# Description : Terraform S3 Bucket module variables.
variable "enabled" {
  type        = bool
  default     = true
  description = "Conditionally create S3 bucket."
}

variable "versioning" {
  type        = bool
  default     = true
  description = "Enable Versioning of S3."
}

variable "acl" {
  type        = string
  default     = null
  description = "Canned ACL to apply to the S3 bucket."
}

variable "enable_server_side_encryption" {
  type        = bool
  default     = false
  description = "Enable enable_server_side_encryption"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms."
}

variable "enable_kms" {
  type        = bool
  default     = false
  description = "Enable enable_server_side_encryption"
}

variable "kms_master_key_id" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}

variable "enable_lifecycle_configuration_rules" {
  type        = bool
  default     = false
  description = "enable or disable lifecycle_configuration_rules"
}

variable "lifecycle_configuration_rules" {
  type = list(object({
    id      = string
    prefix  = string
    enabled = bool
    tags    = map(string)

    enable_glacier_transition            = bool
    enable_deeparchive_transition        = bool
    enable_standard_ia_transition        = bool
    enable_current_object_expiration     = bool
    enable_noncurrent_version_expiration = bool

    abort_incomplete_multipart_upload_days         = number
    noncurrent_version_glacier_transition_days     = number
    noncurrent_version_deeparchive_transition_days = number
    noncurrent_version_expiration_days             = number

    standard_transition_days    = number
    glacier_transition_days     = number
    deeparchive_transition_days = number
    expiration_days             = number
  }))
  default     = null
  description = "A list of lifecycle rules"
}

# Module      : S3 BUCKET POLICY
# Description : Terraform S3 Bucket Policy module variables.
variable "aws_iam_policy_document" {
  type        = string
  default     = ""
  sensitive   = true
  description = "The text of the policy. Although this is a bucket policy rather than an IAM policy, the aws_iam_policy_document data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Note: Bucket policies are limited to 20 KB in size."
}

variable "bucket_policy" {
  type        = bool
  default     = false
  description = "Conditionally create S3 bucket policy."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
}

variable "bucket_prefix" {
  type        = string
  default     = null
  description = " (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix."
}

variable "expected_bucket_owner" {
  type        = string
  default     = null
  description = "The account ID of the expected bucket owner"
}

variable "owner" {
  type        = map(string)
  default     = {}
  description = "Bucket owner's display name and ID. Conflicts with `acl`"
}

variable "grants" {
  type = list(object({
    id          = string
    type        = string
    permissions = list(string)
    uri         = string
  }))
  default     = null
  description = "ACL Policy grant.conflict with acl.set acl null to use this"
}

variable "acl_grants" {
  type = list(object({
    id         = string
    type       = string
    permission = string
    uri        = string
  }))
  default = null

  description = "A list of policy grants for the bucket. Conflicts with `acl`. Set `acl` to `null` to use this."
}

variable "owner_id" {
  type        = string
  default     = ""
  description = "The canonical user ID associated with the AWS account."
}

variable "logging" {
  type        = bool
  default     = false
  description = "Logging Object to enable and disable logging"
}

variable "target_bucket" {
  type        = string
  default     = ""
  description = "The bucket where you want Amazon S3 to store server access logs."
}

variable "target_prefix" {
  type        = string
  default     = ""
  description = "A prefix for all log object keys."
}

variable "acceleration_status" {
  type        = bool
  default     = false
  description = "Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended"
}

variable "request_payer" {
  type        = string
  default     = null
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information."
}

variable "website" {
  type        = any # map(string)
  default     = {}
  description = "Map containing static web-site hosting or redirect configuration."
}

variable "object_lock_configuration" {
  type = object({
    mode  = string #Valid values are GOVERNANCE and COMPLIANCE.
    days  = number
    years = number
  })
  default     = null
  description = "With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely."

}

variable "cors_rule" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default     = null
  description = "CORS Configuration specification for this bucket"
}

variable "replication_configuration" {
  type        = any
  default     = {}
  description = "Map containing cross-region replication configuration."
}

variable "attach_public_policy" {
  type        = bool
  default     = true
  description = "Controls if a user defined public bucket policy will be attached (set to `false` to allow upstream to apply defaults to the bucket)"
}

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket."
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "control_object_ownership" {
  description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "ObjectWriter"
}

variable "configuration_status" {
  type        = string
  default     = "Enabled"
  description = "Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
}

variable "versioning_status" {
  type        = string
  default     = "Enabled"
  description = "Required if versioning_configuration mfa_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device."
}

variable "object_lock_enabled" {
  type        = bool
  default     = false
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
}

variable "analytics_configuration" {
  type        = any
  default     = {}
  description = "Map containing bucket analytics configuration."
}

variable "vpc_endpoints" {
  type    = any
  default = []
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}

variable "s3_name" {
  type        = string
  default     = null
  description = "name of s3 bucket"
}

variable "only_https_traffic" {
  type        = bool
  default     = true
  description = "This veriables use for only https traffic."
}

variable "mfa_delete" {
  type        = string
  default     = "Disabled"
  description = "Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled."
}

variable "intelligent_tiering" {
  type        = any
  default     = {}
  description = "Map containing intelligent tiering configuration."
}

variable "metric_configuration" {
  type        = any
  default     = []
  description = "Map containing bucket metric configuration."
}

variable "inventory_configuration" {
  type        = any
  default     = {}
  description = "Map containing S3 inventory configuration."
}

variable "mfa" {
  type        = string
  default     = null
  description = "Optional, Required if versioning_configuration mfa_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device."
}