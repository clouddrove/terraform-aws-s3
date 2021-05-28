provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket"
  environment = "test"
  label_order = ["name", "environment"]
  acl         = "private"

  bucket_enabled = true

}
