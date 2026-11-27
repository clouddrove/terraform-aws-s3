provider "aws" {
  region = "ca-central-1"
}

module "s3" {
  source      = "../../"
  name        = "s3"
  environment = "test"
}
