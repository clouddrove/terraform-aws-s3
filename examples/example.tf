provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source                 = "git::https://github.com/clouddrove/terraform-aws-s3.git?ref=tags/0.11.0"
  name                   = "devops"
  region                 = "us-east-1"
  application            = "clouddrove"
  environment            = "test"
  versioning             = true
  acl                    = "private"
  }

