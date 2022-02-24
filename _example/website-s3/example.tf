provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-website-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"

  website_config_enable = true

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

  bucket_policy           = true
  aws_iam_policy_document = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid    = "Stmt1447315805704"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::clouddrove-website-bucket-test-public/*"]
  }
}