provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-logging-bucket"
  environment = "test"
  attributes = ["public"]
  label_order = ["name", "environment", "attributes"]

  versioning             = true
  acl                    = "private"
  logging                = {target_bucket:"bucket-logs12",target_prefix= "logs"}
}
