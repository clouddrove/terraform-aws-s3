provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-logging-bucket"
  environment = "test"
  label_order = ["name", "environment"]

  bucket_logging_enabled = true
  target_bucket          = "terraform-clouddrove-test"
  target_prefix          = "logs"
}
