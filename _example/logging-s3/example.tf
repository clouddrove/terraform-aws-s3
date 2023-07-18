####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}
##----------------------------------------------------------------------------------
## Provides details about a logging S3 bucket.
##----------------------------------------------------------------------------------
module "logging_bucket" {
  source = "./../../"

  name        = "logging-s3-test"
  environment = "test"
  label_order = ["name", "environment"]
  acl         = "log-delivery-write"
}

##----------------------------------------------------------------------------------
## Provides details about a specific S3 bucket.
##----------------------------------------------------------------------------------
module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-logging-bucket"
  environment = "test"
  label_order = ["name", "environment"]

  versioning    = true
  acl           = "private"
  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"
  depends_on    = [module.logging_bucket]
}