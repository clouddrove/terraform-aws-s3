#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://registry.terraform.io/modules/clouddrove/s3/aws"
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
  default     = ""
  description = "Canned ACL to apply to the S3 bucket."
}

variable "mfa_delete" {
  type        = bool
  default     = false
  description = "Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms."
}

variable "kms_master_key_id" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  type        = bool
  default     = false
  description = "Specifies infrequent storage transition lifecycle rule status."
}

variable "lifecycle_infrequent_storage_object_prefix" {
  type        = string
  default     = ""
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  sensitive   = true
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
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  sensitive   = true
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
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  sensitive   = true
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
  description = "Specifies the number of days after object creation when the object expires."
  sensitive   = true
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
    id         = string
    type       = string
    permissions = list(string)
    uri        = string
  }))
  default      = null
  description = "ACL Policy grant.conflict with acl.set acl null to use this"
}

variable "website" {
  type = map(string)
  description = "Static website configuration"
  default = {}
  
}

variable "logging" {
  type =map(string)
  description = "Logging Object Configuration details"
  default = {}
  
}

variable "acceleration_status" {
  type = string
  description = "Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended"
  default = null
}

variable "request_payer" {
  type = string
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer"
  default = null
}