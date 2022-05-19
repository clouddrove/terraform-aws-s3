provider "aws" {
  region = "eu-west-1"
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

  name        = "clouddrove-encryption-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]

  versioning                    = true
  acl                           = "private"
  enable_server_side_encryption = true

  enable_kms        = true
  kms_master_key_id = module.kms_key.key_arn
}
