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
  type        = list(string)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources managed by the module (merged with module.labels.tags via extra_tags)."
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
  default     = true
  description = "Enable server-side encryption by default."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256, aws:kms, and aws:kms:dsse."

  validation {
    condition     = contains(["AES256", "aws:kms", "aws:kms:dsse"], var.sse_algorithm)
    error_message = "sse_algorithm must be one of AES256, aws:kms, or aws:kms:dsse."
  }
}

variable "enable_kms" {
  type        = bool
  default     = false
  description = "Enable KMS encryption. If false, uses AES256."
}

variable "kms_master_key_id" {
  type        = string
  default     = null
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}

variable "bucket_key_enabled" {
  type        = bool
  default     = false
  description = "Whether to use an S3 Bucket Key with SSE-KMS. Bucket Keys are not supported with DSSE-KMS."
}

variable "blocked_encryption_types" {
  type        = list(string)
  default     = null
  description = "Encryption types to reject for new object writes. Use [\"SSE-C\"] to block server-side encryption with customer-provided keys."

  validation {
    condition     = var.blocked_encryption_types == null || alltrue([for encryption_type in var.blocked_encryption_types : encryption_type == "SSE-C"])
    error_message = "blocked_encryption_types currently supports only SSE-C."
  }
}

variable "enable_lifecycle_configuration_rules" {
  type        = bool
  default     = false
  description = "enable or disable lifecycle_configuration_rules"
}

variable "lifecycle_configuration_rules" {
  type = list(object({
    id      = string
    enabled = optional(bool, true)
    filter = optional(object({
      prefix                   = optional(string)
      tags                     = optional(map(string), {})
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
    }))

    enable_glacier_transition                        = optional(bool, false)
    enable_deeparchive_transition                    = optional(bool, false)
    enable_standard_ia_transition                    = optional(bool, false)
    enable_noncurrent_version_glacier_transition     = optional(bool, false)
    enable_noncurrent_version_deeparchive_transition = optional(bool, false)
    enable_noncurrent_version_standard_ia_transition = optional(bool, false)
    enable_current_object_expiration                 = optional(bool, false)
    enable_noncurrent_version_expiration             = optional(bool, false)

    abort_incomplete_multipart_upload_days         = optional(number)
    noncurrent_version_glacier_transition_days     = optional(number)
    noncurrent_version_deeparchive_transition_days = optional(number)
    noncurrent_version_standard_ia_transition_days = optional(number)
    noncurrent_version_expiration_days             = optional(number)
    noncurrent_version_expiration_newer            = optional(number)

    noncurrent_version_glacier_transition_newer     = optional(number)
    noncurrent_version_deeparchive_transition_newer = optional(number)
    noncurrent_version_standard_ia_transition_newer = optional(number)

    storage_class = optional(string)

    glacier_storage_class     = optional(string)
    deeparchive_storage_class = optional(string)
    standard_ia_storage_class = optional(string)

    glacier_transition_date     = optional(string)
    standard_ia_transition_date = optional(string)
    deeparchive_transition_date = optional(string)

    standard_transition_days     = optional(number)
    glacier_transition_days      = optional(number)
    deeparchive_transition_days  = optional(number)
    expiration_days              = optional(number)
    expiration_date              = optional(string)
    expired_object_delete_marker = optional(bool)
  }))
  default     = []
  description = "Lifecycle rules for current and noncurrent object transitions, expiration, filtering, and incomplete multipart upload cleanup."

  validation {
    condition = alltrue([
      for rule in var.lifecycle_configuration_rules :
      (!rule.enable_glacier_transition || ((try(rule.glacier_transition_days, null) != null) != (try(rule.glacier_transition_date, null) != null))) &&
      (!rule.enable_deeparchive_transition || ((try(rule.deeparchive_transition_days, null) != null) != (try(rule.deeparchive_transition_date, null) != null))) &&
      (!rule.enable_standard_ia_transition || ((try(rule.standard_transition_days, null) != null) != (try(rule.standard_ia_transition_date, null) != null))) &&
      (!rule.enable_noncurrent_version_glacier_transition || try(rule.noncurrent_version_glacier_transition_days, null) != null) &&
      (!rule.enable_noncurrent_version_deeparchive_transition || try(rule.noncurrent_version_deeparchive_transition_days, null) != null) &&
      (!rule.enable_noncurrent_version_standard_ia_transition || try(rule.noncurrent_version_standard_ia_transition_days, null) != null)
    ])
    error_message = "Enabled current transitions require exactly one of date or days, and enabled noncurrent transitions require noncurrent days."
  }
}

# Module      : S3 BUCKET POLICY
# Description : Terraform S3 Bucket Policy module variables.
variable "aws_iam_policy_document" {
  type        = string
  default     = ""
  sensitive   = true
  description = "The text of the policy. Although this is a bucket policy rather than an IAM policy, the aws_iam_policy_document data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Note: Bucket policies are limited to 20 KB in size."

  validation {
    condition     = var.aws_iam_policy_document == "" || can(jsondecode(var.aws_iam_policy_document))
    error_message = "aws_iam_policy_document must be an empty string or valid JSON."
  }
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
    id          = optional(string)
    type        = string
    permissions = list(string)
    uri         = optional(string)
  }))
  default     = null
  description = "ACL Policy grant.conflict with acl.set acl null to use this"
}

variable "acl_grants" {
  type = list(object({
    id         = optional(string)
    type       = string
    permission = string
    uri        = optional(string)
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

variable "logging_target_grants" {
  type = list(object({
    permission    = string
    type          = string
    id            = optional(string)
    uri           = optional(string)
    email_address = optional(string)
  }))
  default     = []
  description = "Target grants to apply to server access logging delivery."
}

variable "logging_target_object_key_format" {
  type = object({
    partition_date_source = optional(string)
    simple_prefix         = optional(bool, false)
  })
  default     = null
  description = "Server access log object key format. Set partition_date_source to EventTime or DeliveryTime for a partitioned prefix, or simple_prefix to true."

  validation {
    condition = var.logging_target_object_key_format == null || (
      try(var.logging_target_object_key_format.partition_date_source, null) == null ||
      contains(["EventTime", "DeliveryTime"], var.logging_target_object_key_format.partition_date_source)
    )
    error_message = "logging_target_object_key_format.partition_date_source must be EventTime or DeliveryTime."
  }

  validation {
    condition = var.logging_target_object_key_format == null || (
      try(var.logging_target_object_key_format.simple_prefix, false) !=
      (try(var.logging_target_object_key_format.partition_date_source, null) != null)
    )
    error_message = "Choose exactly one of simple_prefix or partition_date_source for the logging target object key format."
  }
}

variable "acceleration_status" {
  type        = bool
  default     = false
  description = "Whether to manage and enable the S3 Transfer Acceleration configuration."
}

variable "request_payer" {
  type        = string
  default     = null
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information."

  validation {
    condition     = var.request_payer == null || contains(["BucketOwner", "Requester"], var.request_payer)
    error_message = "request_payer must be either BucketOwner or Requester."
  }
}

variable "website" {
  type        = any # map(string)
  default     = {}
  description = "Map containing static web-site hosting or redirect configuration."
}

variable "object_lock_configuration" {
  type = object({
    mode  = string # Valid values are GOVERNANCE and COMPLIANCE.
    days  = optional(number)
    years = optional(number)
    token = optional(string)
  })
  default     = null
  description = "With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely."

  validation {
    condition     = var.object_lock_configuration == null || contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_configuration.mode)
    error_message = "object_lock_configuration.mode must be GOVERNANCE or COMPLIANCE."
  }

  validation {
    condition = var.object_lock_configuration == null || (
      (try(var.object_lock_configuration.days, null) != null) !=
      (try(var.object_lock_configuration.years, null) != null)
    )
    error_message = "Set exactly one of object_lock_configuration.days or object_lock_configuration.years."
  }
}

variable "cors_rule" {
  type = list(object({
    id              = optional(string)
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number)
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
  description = "Whether to manage the S3 bucket Public Access Block configuration."
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
  default     = true
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}

variable "configuration_status" {
  type        = string
  default     = "Enabled"
  description = "Transfer Acceleration status. Valid values are Enabled and Suspended."

  validation {
    condition     = contains(["Enabled", "Suspended"], var.configuration_status)
    error_message = "configuration_status must be Enabled or Suspended."
  }
}

variable "versioning_status" {
  type        = string
  default     = "Enabled"
  description = "Versioning state of the bucket. Valid values are Enabled, Suspended, and Disabled."

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "versioning_status must be Enabled, Suspended, or Disabled."
  }
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
  type        = any
  default     = []
  description = "List of VPC endpoint configurations to create for S3 access within a VPC."
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

variable "notification_configuration" {
  type = object({
    eventbridge = optional(bool, false)
    lambda_functions = optional(list(object({
      id                  = optional(string)
      lambda_function_arn = string
      events              = set(string)
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
    })), [])
    queues = optional(list(object({
      id            = optional(string)
      queue_arn     = string
      events        = set(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
    topics = optional(list(object({
      id            = optional(string)
      topic_arn     = string
      events        = set(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
  })
  default     = null
  description = "Complete S3 event notification configuration. This module manages the bucket's single atomic notification configuration."
}

variable "abac_status" {
  type        = string
  default     = null
  description = "Optional S3 bucket ABAC status. Valid values are Enabled and Disabled."

  validation {
    condition     = var.abac_status == null || contains(["Enabled", "Disabled"], var.abac_status)
    error_message = "abac_status must be Enabled or Disabled."
  }
}

variable "metadata_configuration" {
  type = object({
    inventory_table = optional(object({
      configuration_state = optional(string, "ENABLED")
      encryption = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
    }))
    journal_table = optional(object({
      record_expiration = optional(object({
        expiration = string
        days       = optional(number)
      }), { expiration = "DISABLED" })
      encryption = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
    }), {})
  })
  default     = null
  description = "S3 Metadata table configuration for the bucket. Metadata tables are available only in supported AWS Regions."

  validation {
    condition = var.metadata_configuration == null || (
      try(var.metadata_configuration.inventory_table.configuration_state, "ENABLED") == "ENABLED" ||
      try(var.metadata_configuration.inventory_table.configuration_state, "ENABLED") == "DISABLED"
    )
    error_message = "metadata_configuration.inventory_table.configuration_state must be ENABLED or DISABLED."
  }

  validation {
    condition = var.metadata_configuration == null || (
      try(var.metadata_configuration.journal_table.record_expiration.expiration, "DISABLED") == "ENABLED" ||
      try(var.metadata_configuration.journal_table.record_expiration.expiration, "DISABLED") == "DISABLED"
    )
    error_message = "metadata_configuration.journal_table.record_expiration.expiration must be ENABLED or DISABLED."
  }

  validation {
    condition = var.metadata_configuration == null || (
      try(var.metadata_configuration.journal_table.record_expiration.expiration, "DISABLED") != "ENABLED" ||
      try(var.metadata_configuration.journal_table.record_expiration.days, null) != null
    )
    error_message = "metadata_configuration journal expiration days must be set when expiration is ENABLED."
  }
}

variable "only_https_traffic" {
  type        = bool
  default     = true
  description = "Whether to add a bucket policy statement that denies requests made without TLS."
}

variable "block_http_bucket_policy" {
  type        = string
  default     = null
  description = "Optional JSON policy document that replaces the generated statement used to deny non-HTTPS traffic."

  validation {
    condition     = var.block_http_bucket_policy == null || can(jsondecode(var.block_http_bucket_policy))
    error_message = "block_http_bucket_policy must be null or valid JSON."
  }
}

variable "mfa_delete" {
  type        = string
  default     = "Disabled"
  description = "Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled."

  validation {
    condition     = contains(["Enabled", "Disabled"], var.mfa_delete)
    error_message = "mfa_delete must be Enabled or Disabled."
  }
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
