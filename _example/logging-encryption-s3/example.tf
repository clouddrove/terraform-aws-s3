####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

locals {
  environment = "test"
  label_order = ["name", "environment"]
}

##----------------------------------------------------------------------------------
## Provides details about a logging S3 bucket.
##----------------------------------------------------------------------------------
module "logging_bucket" {
  source = "./../../"

  name        = "logging"
  s3_name     = "quya"
  environment = local.environment
  label_order = local.label_order
  acl         = "log-delivery-write"
}

##----------------------------------------------------------------------------------
## Below resources will create KMS-KEY and its components.
##----------------------------------------------------------------------------------
module "kms_key" {
  source      = "clouddrove/kms/aws"
  version     = "1.3.1"
  name        = "kms"
  environment = local.environment
  label_order = local.label_order

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

  name        = "clouddrove-logging-encryption-bucket"
  s3_name     = "aqua"
  environment = local.environment
  label_order = local.label_order

  versioning                    = true
  acl                           = "private"
  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn
  logging                       = true
  target_bucket                 = module.logging_bucket.id
  target_prefix                 = "logs"
  depends_on                    = [module.logging_bucket]
}