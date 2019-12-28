provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "secure-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  region         = "eu-west-1"
  versioning     = true
  acl            = "private"
  bucket_enabled = true
}