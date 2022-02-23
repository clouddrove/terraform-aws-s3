provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket"
  environment = "test"
  attributes  = ["private"]
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"
}