provider "aws" {
  region = "eu-west-1"
}

module "kms_key" {
  source                  = "git::https://github.com/terraform-aws-kms.git?ref=0.14"
  name                    = "kms"
  repository              = "https://registry.terraform.io/modules/clouddrove/kms/aws/0.14.0"
  environment             = "test"
  label_order             = ["name", "environment"]
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

  name                      = "encryption-bucket"
  repository                = "https://registry.terraform.io/modules/clouddrove/s3/aws/0.14.0"
  environment               = "test"
  label_order               = ["name", "environment"]
  versioning                = true
  acl                       = "private"
  bucket_encryption_enabled = true
  sse_algorithm             = "aws:kms"
  kms_master_key_id         = module.kms_key.key_arn
}