provider "aws" {
  region = "eu-west-1"
}


module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket-new-version"
  environment = "test"
  attributes  = ["private"]
  label_order = ["name", "environment"]

  acl = "private"

  versioning          = true
  acceleration_status = true
  request_payer       = true

  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"

  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn

  object_lock_configuration = {
    mode  = "GOVERNANCE"
    days  = 366
    years = null
  }

  cors_rule = [{
    allowed_headers = ["*"],
    allowed_methods = ["PUT", "POST"],
    allowed_origins = ["https://s3-website-test.hashicorp.com"],
    expose_headers  = ["ETag"],
    max_age_seconds = 3000
  }]

  # this is not working 

#   website_inputs = [{
#     index_document           = "index.html"
#     error_document           = "error.html"
#     redirect_all_requests_to = null
#     routing_rules            = null
#   }]
   
   grants = [
  {
    id          = null
    type        = "Group"
    permissions = ["READ", "WRITE"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  },
  ]
   owner_id = data.aws_canonical_user_id.current.id


  enable_lifecycle_configuration_rules = true 
  lifecycle_configuration_rules = [
  { 
    id = "log"
    prefix  = null
    enabled = true
    tags    = { "temp" : "true" }

    enable_glacier_transition            = false
    enable_deeparchive_transition        = false
    enable_standard_ia_transition        = false
    enable_current_object_expiration     = true
    enable_noncurrent_version_expiration = true

    abort_incomplete_multipart_upload_days         = null
    noncurrent_version_glacier_transition_days     = 0
    noncurrent_version_deeparchive_transition_days = 0
    noncurrent_version_expiration_days             = 30

    standard_transition_days    = 0
    glacier_transition_days     = 0
    deeparchive_transition_days = 0
    expiration_days             = 365
  },
  {
    id = "log1"
    prefix  = null
    enabled = true
    tags    = {}

    enable_glacier_transition            = false
    enable_deeparchive_transition        = false
    enable_standard_ia_transition        = false
    enable_current_object_expiration     = true
    enable_noncurrent_version_expiration = true

    abort_incomplete_multipart_upload_days         = 1
    noncurrent_version_glacier_transition_days     = 0
    noncurrent_version_deeparchive_transition_days = 0
    noncurrent_version_expiration_days             = 30

    standard_transition_days    = 0
    glacier_transition_days     = 0
    deeparchive_transition_days = 0
    expiration_days             = 365
  }
]
}

data "aws_canonical_user_id" "current" {}