provider "aws" {
  region = "us-east-1"
}

module "s3_lifecycle" {
  source        = "../../"
  name          = "cd-s3-lifecycle-demo"
  environment   = "test"
  force_destroy = true

  enable_lifecycle_configuration_rules = true

  lifecycle_configuration_rules = [
    # 1. USE CASE 1: Application Logs (Move to Standard-IA after 30 days, delete after 90 days)
    {
      id      = "logs-ia-then-delete"
      enabled = true
      filter  = { prefix = "logs/" }

      enable_standard_ia_transition                   = true
      storage_class                                   = "STANDARD_IA"
      standard_transition_days                        = 30
      noncurrent_version_glacier_transition_days      = 30
      noncurrent_version_standard_ia_transition_newer = 1

      enable_current_object_expiration     = true
      expiration_days                      = 90
      enable_noncurrent_version_expiration = true
      noncurrent_version_expiration_days   = 30

      enable_glacier_transition              = false
      enable_deeparchive_transition          = false
      abort_incomplete_multipart_upload_days = 7
    },

    # 2. USE CASE 2: Database & App Backups (Move to Glacier after 60 days, never delete current files)
    {
      id      = "backups-to-glacier"
      enabled = true
      filter  = { prefix = "backups/" }

      enable_glacier_transition                   = true
      storage_class                               = "GLACIER"
      glacier_transition_days                     = 60
      noncurrent_version_glacier_transition_days  = 30
      noncurrent_version_glacier_transition_newer = 1

      enable_current_object_expiration     = false
      enable_noncurrent_version_expiration = true
      noncurrent_version_expiration_days   = 90 # Must be <= 100 due to main.tf line 356

      enable_standard_ia_transition          = false
      enable_deeparchive_transition          = false
      abort_incomplete_multipart_upload_days = 7
    },

    # 3. USE CASE 3: Compliance Archive (Move to Deep Archive after 180 days, delete after 7 years)
    {
      id      = "archive-to-deep-archive"
      enabled = true
      filter  = { prefix = "archive/" }

      enable_deeparchive_transition                   = true
      storage_class                                   = "DEEP_ARCHIVE"
      deeparchive_transition_days                     = 180
      noncurrent_version_deeparchive_transition_days  = 90
      noncurrent_version_deeparchive_transition_newer = 1

      enable_current_object_expiration     = true
      expiration_days                      = 2555
      enable_noncurrent_version_expiration = true
      noncurrent_version_expiration_days   = 100 # Must be <= 100 due to main.tf line 356

      enable_standard_ia_transition          = false
      enable_glacier_transition              = false
      abort_incomplete_multipart_upload_days = 7
    }
  ]
}
