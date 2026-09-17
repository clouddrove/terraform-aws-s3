provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "../../"

  name          = "modern-s3"
  environment   = "test"
  bucket_prefix = "modern-s3-"

  sse_algorithm            = "aws:kms"
  bucket_key_enabled       = true
  blocked_encryption_types = ["SSE-C"]
  abac_status              = "Enabled"

  notification_configuration = {
    eventbridge = true
  }

  metadata_configuration = {
    inventory_table = {
      configuration_state = "ENABLED"
    }
    journal_table = {
      record_expiration = {
        expiration = "ENABLED"
        days       = 30
      }
    }
  }
}
