provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "logging-encryption-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  region                            = "eu-west-1"
  versioning                        = true
  acl                               = "private"
  bucket_logging_encryption_enabled = true
  sse_algorithm                     = "AES256"
  target_bucket                     = "bucket-logs12"
  target_prefix                     = "logs"
}
