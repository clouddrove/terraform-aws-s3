
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
  version     = "1.0.1"
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

  name        = "clouddrove-logging-encryption-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"

  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn

  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"

  depends_on = [module.logging_bucket]
}