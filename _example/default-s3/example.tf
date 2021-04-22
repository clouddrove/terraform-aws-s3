provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment", "attributes"]

  versioning     = true
  acl            = "private"
}
