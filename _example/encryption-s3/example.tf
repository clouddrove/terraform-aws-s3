provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "git::https://github.com/clouddrove/terraform-aws-s3.git"

  name        = "encryption-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  region             = "eu-west-1"
  versioning         = true
  acl                = "private"
  encryption_enabled = true
  sse_algorithm      = "AES256"
}