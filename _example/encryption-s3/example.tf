provider "aws" {
  region = "eu-west-1"
}

module "kms_key" {
  source                  = "git::https://github.com/clouddrove/terraform-aws-kms.git?ref=tags/0.12.4"
  name                    = "kms"
  application             = "clouddrove"
  environment             = "test"
  label_order             = ["environment", "application", "name"]
  enabled                 = true
  description             = "KMS key for cloudtrail"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/cloudtrail"
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

  name        = "encryption-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  region                    = "eu-west-1"
  versioning                = true
  acl                       = "private"
  bucket_encryption_enabled = true
  sse_algorithm             = "aws:kms"
  kms_master_key_id         = module.kms_key.key_arn
}