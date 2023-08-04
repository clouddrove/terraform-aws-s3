####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

##----------------------------------------------------------------------------------
## Provides details about a default S3 bucket.
##----------------------------------------------------------------------------------
module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket"
  environment = "test"
  label_order = ["name", "environment"]
  acl         = "private"
  versioning  = true
}