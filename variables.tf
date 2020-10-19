#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map
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
  default     = false
  description = "Enable Versioning of S3."
}

variable "acl" {
  type        = string
  default     = ""
  description = "Canned ACL to apply to the S3 bucket."
}

variable "bucket_enabled" {
  type        = bool
  default     = false
  description = "Enable simple S3."
}

variable "mfa_delete" {
  type        = bool
  default     = false
  description = "Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version."
}

variable "bucket_logging_enabled" {
  type        = bool
  default     = false
  description = "Enable logging of S3."
}

variable "bucket_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable encryption of S3."
}

variable "bucket_logging_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable logging encryption of S3."
}

variable "website_hosting_bucket" {
  type        = bool
  default     = false
  description = "Enable website hosting of S3."
}

variable "target_bucket" {
  type        = string
  default     = ""
  description = "The name of the bucket that will receive the log objects."
}

variable "target_prefix" {
  type        = string
  default     = ""
  description = "To specify a key prefix for log objects."
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

variable "website_index" {
  type        = string
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders."
}

variable "website_error" {
  type        = string
  default     = "error.html"
  description = "An absolute path to the document to return in case of a 4XX error."
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