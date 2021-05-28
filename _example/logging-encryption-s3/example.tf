provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-logging-encryption-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment", "attributes"]

  versioning    = true
  acl           = "private"
  sse_algorithm = "AES256"
  logging       = { target_bucket : "bucket-logs12", target_prefix = "logs" }
}
