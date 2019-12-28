provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "website-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  region                             = "eu-west-1"
  versioning                         = true
  acl                                = "private"
  website_hosting_bucket             = true
  website_index                      = "index.html"
  website_error                      = "error.html"
  lifecycle_expiration_enabled       = true
  lifecycle_expiration_object_prefix = "test"
  lifecycle_days_to_expiration       = 10

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
    resources = ["arn:aws:s3:::test-clouddrove-website-bucket/*"]
  }
}