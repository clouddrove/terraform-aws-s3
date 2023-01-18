provider "aws" {
  region = "eu-west-1"
}

module "logging_bucket" {
  source = "./../../"

  name        = "logging"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]
  acl         = "log-delivery-write"
}

module "kms_key" {
  source      = "clouddrove/kms/aws"
  version     = "1.3.0"
  name        = "kms"
  environment = "test"
  label_order = ["name", "environment"]

  enabled                 = true
  description             = "KMS key for s3"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/s3"
  policy                  = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket-new-version"
  environment = "test"
  attributes  = ["private"]
  label_order = ["name", "environment"]

  acl = ""
  #enable of disable versioning of s3 
  versioning = true

  #acceleration and request payer enable or disable.  
  acceleration_status = true
  request_payer       = true

  # logging of s3 bucket to destination bucket. 
  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"

  #encrption on s3 with default encryption and kms encryption . 
  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn

  #object locking of s3. 
  object_lock_configuration = {
    mode  = "GOVERNANCE"
    days  = 366
    years = null
  }

  #cross replicaton of s3 
  cors_rule = [{
    allowed_headers = ["*"],
    allowed_methods = ["PUT", "POST"],
    allowed_origins = ["https://s3-website-test.hashicorp.com"],
    expose_headers  = ["ETag"],
    max_age_seconds = 3000
  }]

  #acl grant permission 
  grants = [
    {
      id          = null
      type        = "Group"
      permissions = ["READ", "WRITE"]
      uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    },
  ]
  owner_id = data.aws_canonical_user_id.current.id


  #lifecycle rule for s3 
  enable_lifecycle_configuration_rules = true
  lifecycle_configuration_rules = [
    {
      id      = "log"
      prefix  = null
      enabled = true
      tags    = { "temp" : "true" }

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false
      enable_current_object_expiration     = true
      enable_noncurrent_version_expiration = true

      abort_incomplete_multipart_upload_days         = null
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      noncurrent_version_expiration_days             = 30

      standard_transition_days    = 0
      glacier_transition_days     = 0
      deeparchive_transition_days = 0
      expiration_days             = 365
    },
    {
      id      = "log1"
      prefix  = null
      enabled = true
      tags    = {}

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false
      enable_current_object_expiration     = true
      enable_noncurrent_version_expiration = true

      abort_incomplete_multipart_upload_days         = 1
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      noncurrent_version_expiration_days             = 30

      standard_transition_days    = 0
      glacier_transition_days     = 0
      deeparchive_transition_days = 0
      expiration_days             = 365
    }
  ]

  #static website on s3
  website_config_enable = true

}

data "aws_canonical_user_id" "current" {}