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
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}

variable "bucket_key_enabled" {
  type        = bool
  default     = null
  description = "Whether to use an S3 Bucket Key for SSE-KMS. Leave null to use the AWS default."

  validation {
    condition     = var.bucket_key_enabled != true || var.enable_kms || var.sse_algorithm == "aws:kms"
    error_message = "bucket_key_enabled can only be true when the effective sse_algorithm is aws:kms; S3 Bucket Keys are not supported with AES256 or aws:kms:dsse."
  }
}

variable "blocked_encryption_types" {
  type        = list(string)
  default     = null
  description = "Encryption types to block for object uploads. Supported values are SSE-C or NONE."

  validation {
    condition = var.blocked_encryption_types == null ? true : (
      length(var.blocked_encryption_types) == 1 &&
      contains(["SSE-C", "NONE"], var.blocked_encryption_types[0])
    )
    error_message = "blocked_encryption_types must be null or a single-item list containing SSE-C or NONE."
  }
}

variable "enable_lifecycle_configuration_rules" {
  type        = bool
  default     = false
  description = "enable or disable lifecycle_configuration_rules"
}

variable "transition_default_minimum_object_size" {
  type        = string
  default     = null
  description = "Default minimum object size behavior for lifecycle transitions. Valid values are all_storage_classes_128K and varies_by_storage_class."

  validation {
    condition     = var.transition_default_minimum_object_size == null ? true : contains(["all_storage_classes_128K", "varies_by_storage_class"], var.transition_default_minimum_object_size)
    error_message = "transition_default_minimum_object_size must be null, all_storage_classes_128K, or varies_by_storage_class."
  }
}

variable "lifecycle_configuration_rules" {
  type = list(object({
    id      = string
    enabled = bool
    filter  = any

    enable_glacier_transition            = bool
    enable_deeparchive_transition        = bool
    enable_standard_ia_transition        = bool
    enable_current_object_expiration     = bool
    enable_noncurrent_version_expiration = bool

    abort_incomplete_multipart_upload_days         = number
    noncurrent_version_glacier_transition_days     = optional(number)
    noncurrent_version_deeparchive_transition_days = optional(number)
    noncurrent_version_standard_ia_transition_days = optional(number)
    noncurrent_version_expiration_days             = optional(number)
    noncurrent_version_expiration_newer            = optional(number)

    noncurrent_version_glacier_transition_newer     = optional(number)
    noncurrent_version_deeparchive_transition_newer = optional(number)
    noncurrent_version_standard_ia_transition_newer = optional(number)

    storage_class = optional(string)

    glacier_transition_date     = optional(number)
    standard_ia_transition_date = optional(number)
    deeparchive_transition_date = optional(number)

    standard_transition_days    = optional(number)
    glacier_transition_days     = optional(number)
    deeparchive_transition_days = optional(number)
    expiration_days             = optional(number)
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

variable "logging_target_grants" {
  type = list(object({
    permission = string
    grantee = object({
      type          = string
      id            = optional(string)
      email_address = optional(string)
      uri           = optional(string)
    })
  }))
  default     = []
  description = "Optional grants applied to the server access logging destination. Bucket policies are preferred by AWS."
}

variable "logging_target_object_key_format" {
  type = object({
    partition_date_source = optional(string)
    use_simple_prefix     = optional(bool, false)
  })
  default     = null
  description = "Server access log object key format. Set partition_date_source to EventTime or DeliveryTime, or set use_simple_prefix to true."

  validation {
    condition = var.logging_target_object_key_format == null ? true : (
      (try(var.logging_target_object_key_format.partition_date_source, null) != null) !=
      try(var.logging_target_object_key_format.use_simple_prefix, false)
    )
    error_message = "Choose exactly one logging key format: partition_date_source or use_simple_prefix."
  }

  validation {
    condition = var.logging_target_object_key_format == null ? true : try(
      contains(["EventTime", "DeliveryTime"], var.logging_target_object_key_format.partition_date_source),
      true
    )
    error_message = "partition_date_source must be EventTime or DeliveryTime."
  }
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

  validation {
    condition     = var.request_payer == null ? true : contains(["bucketowner", "requester"], lower(var.request_payer))
    error_message = "request_payer must be null, BucketOwner, or Requester."
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
    condition = var.object_lock_configuration == null ? true : (
      contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_configuration.mode) &&
      ((try(var.object_lock_configuration.days, null) != null) != (try(var.object_lock_configuration.years, null) != null))
    )
    error_message = "object_lock_configuration mode must be GOVERNANCE or COMPLIANCE and exactly one of days or years must be set."
  }
}

variable "cors_rule" {
  type = list(object({
    id              = optional(string)
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
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

variable "only_https_traffic" {
  type        = bool
  default     = true
  description = "This veriables use for only https traffic."
}

variable "block_http_bucket_policy" {
  type        = any
  default     = null
  description = "Custome bucket policy to block https traffic"
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

variable "notification_configuration" {
  type = object({
    eventbridge = optional(bool, false)
    lambda_functions = optional(list(object({
      id                  = optional(string)
      lambda_function_arn = string
      events              = list(string)
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
    })), [])
    queues = optional(list(object({
      id            = optional(string)
      queue_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
    topics = optional(list(object({
      id            = optional(string)
      topic_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
  })
  default     = null
  description = "S3 event notification configuration for EventBridge, Lambda, SQS, and SNS. This resource manages the bucket's complete notification configuration."
}

variable "abac_status" {
  type        = string
  default     = null
  description = "Enable or disable attribute-based access control for the general purpose bucket. Valid values are Enabled and Disabled."

  validation {
    condition     = var.abac_status == null ? true : contains(["Enabled", "Disabled"], var.abac_status)
    error_message = "abac_status must be null, Enabled, or Disabled."
  }
}

variable "metadata_configuration" {
  type = object({
    inventory_table_configuration = object({
      configuration_state = string
      encryption_configuration = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
    })
    journal_table_configuration = object({
      encryption_configuration = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
      record_expiration = object({
        expiration = string
        days       = optional(number)
      })
    })
  })
  default     = null
  description = "Amazon S3 Metadata configuration for live inventory and journal tables. Creating these tables can incur S3 Tables and backfill charges."

  validation {
    condition = var.metadata_configuration == null ? true : (
      contains(["ENABLED", "DISABLED"], var.metadata_configuration.inventory_table_configuration.configuration_state) &&
      contains(["ENABLED", "DISABLED"], var.metadata_configuration.journal_table_configuration.record_expiration.expiration)
    )
    error_message = "Metadata inventory configuration_state and journal record expiration must be ENABLED or DISABLED."
  }

  validation {
    condition = var.metadata_configuration == null ? true : alltrue([
      for encryption in [
        try(var.metadata_configuration.inventory_table_configuration.encryption_configuration, null),
        try(var.metadata_configuration.journal_table_configuration.encryption_configuration, null)
      ] : encryption == null ? true : contains(["AES256", "aws:kms"], encryption.sse_algorithm)
    ])
    error_message = "Metadata table sse_algorithm must be AES256 or aws:kms."
  }
}

variable "mfa" {
  type        = string
  default     = null
  description = "Optional, Required if versioning_configuration mfa_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device."
}
