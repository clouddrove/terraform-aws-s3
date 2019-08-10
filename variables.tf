variable "application" {
  type        = "string"
  description = "Organization (e.g. `cd` or `anmolnagpal`)"
}

variable "environment" {
  type        = "string"
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  description = "A mapping of tags to assign to bucket"
  default     = {}
}
variable "create_bucket" {
  description = "Conditionally create S3 bucket"
  default     = true
}

variable "versioning" {
  description = "Enable Versioning of S3 "
  default     = false
}
variable "region" {
  default     = ""
  description = "Region Where you want to host S3"
}
variable "acl" {
  type        = "string"
  description = "Canned ACL to apply to the S3 bucket"
  default     = ""
}
