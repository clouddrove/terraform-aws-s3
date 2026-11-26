provider "aws" {
  region = "us-east-1"
}

module "s3_lifecycle" {
  source        = "../../"
  name          = "clouddrove-s3-lifecycle-demo"
  environment   = "test"
  force_destroy = true

  enable_lifecycle_configuration_rules = true

  lifecycle_configuration_rules = [
    {
      id      = "expire-old-objects"
      enabled = true
      filter  = {}

      enable_current_object_expiration     = true
      expiration_days                      = 30
      enable_noncurrent_version_expiration = true
      noncurrent_version_expiration_days   = 7

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false

      abort_incomplete_multipart_upload_days = 7
    }
  ]
}
