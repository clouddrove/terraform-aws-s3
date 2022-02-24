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
  cors_rule = [{
    allowed_headers = ["*"],
    allowed_methods = ["PUT", "POST"],
    allowed_origins = ["https://s3-website-test.hashicorp.com"],
    expose_headers  = ["ETag"],
    max_age_seconds = 3000
  }]
}
