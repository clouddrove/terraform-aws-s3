provider "aws" {
  region = "eu-west-1"
}

module "logging_bucket" {
  source = "./../../"

  name        = "logging-s3"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]
  acl         = "log-delivery-write"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-logging-bucket"
  environment = "test"
  attributes  = ["public"]
  label_order = ["name", "environment"]

  versioning    = true
  acl           = "private"
  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"

  depends_on = [module.logging_bucket]

}