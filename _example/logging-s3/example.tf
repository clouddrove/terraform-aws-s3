provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name                   = "logging-bucket"
  repository             = "https://registry.terraform.io/modules/clouddrove/s3/aws/0.14.0"
  environment            = "test"
  label_order            = ["name", "environment"]
  versioning             = true
  acl                    = "private"
  bucket_logging_enabled = true

  target_bucket = "terraform-gitlab-ajay-test"
  target_prefix = "logs"
}