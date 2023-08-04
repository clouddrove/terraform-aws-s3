####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

##----------------------------------------------------------------------------------
## Provides details about a specific S3 bucket.
##----------------------------------------------------------------------------------
module "logging_bucket" {
  source = "./../../"

  name        = "logging"
  environment = "test"
  label_order = ["name", "environment"]
  acl         = "log-delivery-write"
}

##----------------------------------------------------------------------------------
## Below resources will create KMS-KEY and its components.
##----------------------------------------------------------------------------------
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

##----------------------------------------------------------------------------------
## Generates an IAM policy document in JSON format for use with resources that expect policy documents such as aws_iam_policy.
##----------------------------------------------------------------------------------
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

##----------------------------------------------------------------------------------
## Provides details about a specific S3 bucket.
##----------------------------------------------------------------------------------
module "s3_bucket" {
  source = "./../../"

  name        = "bucket-new-version"
  environment = "test"
  label_order = ["name", "environment"]

  #acceleration and request payer enable or disable.  
  acceleration_status = true
  request_payer       = "BucketOwner"
  object_lock_enabled = "Enabled"
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

  versioning = true

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
      id                                             = "log"
      prefix                                         = null
      enabled                                        = true
      tags                                           = { "temp" : "true" }
      enable_glacier_transition                      = false
      enable_deeparchive_transition                  = false
      enable_standard_ia_transition                  = false
      enable_current_object_expiration               = true
      enable_noncurrent_version_expiration           = true
      abort_incomplete_multipart_upload_days         = null
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      noncurrent_version_expiration_days             = 30
      standard_transition_days                       = 0
      glacier_transition_days                        = 0
      deeparchive_transition_days                    = 0
      storage_class                                  = "GLACIER"
      expiration_days                                = 365
    },
    {
      id                                             = "log1"
      prefix                                         = null
      enabled                                        = true
      tags                                           = {}
      enable_glacier_transition                      = false
      enable_deeparchive_transition                  = false
      enable_standard_ia_transition                  = false
      enable_current_object_expiration               = true
      enable_noncurrent_version_expiration           = true
      abort_incomplete_multipart_upload_days         = 1
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      storage_class                                  = "DEEP_ARCHIVE"
      noncurrent_version_expiration_days             = 30
      standard_transition_days                       = 0
      glacier_transition_days                        = 0
      deeparchive_transition_days                    = 0
      expiration_days                                = 365
    }
  ]

  #static website on s3
  website = {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = [{
      condition = {
        key_prefix_equals = "docs/"
      },
      redirect = {
        replace_key_prefix_with = "documents/"
      }
      }, {
      condition = {
        http_error_code_returned_equals = 404
        key_prefix_equals               = "archive/"
      },
      redirect = {
        host_name          = "archive.myhost.com"
        http_redirect_code = 301
        protocol           = "https"
        replace_key_with   = "not_found.html"
      }
    }]
  }

}
data "aws_canonical_user_id" "current" {}