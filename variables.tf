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

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

# Module      : S3 BUCKET
# Description : Terraform S3 Bucket module variables.
variable "create_bucket" {
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

variable "mfa_delete" {
  type        = bool
  default     = false
  description = "Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version."
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

variable "lifecycle_infrequent_storage_transition_enabled" {
  type        = bool
  default     = false
  description = "Specifies infrequent storage transition lifecycle rule status."
}

variable "lifecycle_infrequent_storage_object_prefix" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  type        = number
  default     = 60
  description = "Specifies the number of days after object creation when it will be moved to standard infrequent access storage."
}

variable "lifecycle_glacier_transition_enabled" {
  type        = bool
  default     = false
  description = "Specifies Glacier transition lifecycle rule status."
}

variable "lifecycle_glacier_object_prefix" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
}

variable "lifecycle_days_to_deep_archive_transition" {
  type        = number
  default     = 180
  description = "Specifies the number of days after object creation when it will be moved to DEEP ARCHIVE ."
}

variable "lifecycle_deep_archive_transition_enabled" {
  type        = bool
  default     = false
  description = "Specifies DEEP ARCHIVE transition lifecycle rule status."
}

variable "lifecycle_deep_archive_object_prefix" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
}

variable "lifecycle_days_to_glacier_transition" {
  type        = number
  default     = 180
  description = "Specifies the number of days after object creation when it will be moved to Glacier storage."
}

variable "lifecycle_expiration_enabled" {
  type        = bool
  default     = false
  description = "Specifies expiration lifecycle rule status."
}

variable "lifecycle_expiration_object_prefix" {
  type        = string
  default     = ""
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
}

variable "lifecycle_days_to_expiration" {
  type        = number
  default     = 365
  description = "Specifies the number of days after object creation when the object expires."
}

# Module      : S3 BUCKET POLICY
# Description : Terraform S3 Bucket Policy module variables.
variable "aws_iam_policy_document" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Specifies the number of days after object creation when the object expires."
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

variable "website_config_enable" {
  type        = bool
  default     = false
  description = "enable or disable aws_s3_bucket_website_configuration"
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "The name of the index document for the website"
}
variable "error_document" {
  type        = string
  default     = "error.html"
  description = "he name of the error document for the website "
}
variable "routing_rule" {
  type        = string
  default     = "docs/"
  description = "ist of rules that define when a redirect is applied and the redirect behavior "
}
variable "redirect" {
  type        = string
  default     = "documents/"
  description = "The redirect behavior for every request to this bucket's website endpoint "
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
  type        = bool
  default     = false
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer"
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
  description = "Map containing cross-region replication configuration."
  type        = any
  default     = {}
}

variable "attach_public_policy" {
  description = "Controls if a user defined public bucket policy will be attached (set to `false` to allow upstream to apply defaults to the bucket)"
  type        = bool
  default     = true
}
variable "attach_elb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ELB log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_lb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ALB/NLB log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_deny_insecure_transport_policy" {
  description = "Controls if S3 bucket should have deny non-SSL transport policy attached"
  type        = bool
  default     = false
}

variable "attach_require_latest_tls_policy" {
  description = "Controls if S3 bucket should require the latest version of TLS"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = false
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
variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}