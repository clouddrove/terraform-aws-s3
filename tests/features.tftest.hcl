mock_provider "aws" {}

variables {
  name                                   = "features"
  environment                            = "test"
  label_order                            = ["name", "environment"]
  s3_name                                = "module-features-test"
  only_https_traffic                     = false
  attach_public_policy                   = false
  versioning                             = true
  acl                                    = "private"
  request_payer                          = "Requester"
  sse_algorithm                          = "aws:kms"
  kms_master_key_id                      = "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000000"
  bucket_key_enabled                     = true
  blocked_encryption_types               = ["SSE-C"]
  enable_lifecycle_configuration_rules   = true
  transition_default_minimum_object_size = "varies_by_storage_class"
  lifecycle_configuration_rules = [{
    id                                              = "archive"
    enabled                                         = true
    filter                                          = { prefix = "archive/", object_size_greater_than = 1024 }
    enable_glacier_transition                       = false
    enable_deeparchive_transition                   = false
    enable_standard_ia_transition                   = true
    enable_current_object_expiration                = false
    enable_noncurrent_version_expiration            = false
    abort_incomplete_multipart_upload_days          = null
    noncurrent_version_standard_ia_transition_days  = 60
    noncurrent_version_standard_ia_transition_newer = 2
    standard_transition_days                        = 30
    storage_class                                   = "STANDARD_IA"
  }]
  logging       = true
  target_bucket = "module-access-logs-test"
  target_prefix = "access/"
  logging_target_object_key_format = {
    partition_date_source = "EventTime"
  }
  logging_target_grants = [{
    permission = "READ"
    grantee = {
      type = "CanonicalUser"
      id   = "0000000000000000000000000000000000000000000000000000000000000000"
    }
  }]
  notification_configuration = {
    eventbridge = true
    lambda_functions = [{
      id                  = "images"
      lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:image-processor"
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = "images/"
    }]
    queues = [{
      id        = "deletions"
      queue_arn = "arn:aws:sqs:us-east-1:123456789012:deletions"
      events    = ["s3:ObjectRemoved:*"]
    }]
    topics = [{
      id            = "logs"
      topic_arn     = "arn:aws:sns:us-east-1:123456789012:logs"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".log"
    }]
  }
  abac_status = "Enabled"
  metadata_configuration = {
    inventory_table_configuration = {
      configuration_state = "ENABLED"
      encryption_configuration = {
        sse_algorithm = "AES256"
      }
    }
    journal_table_configuration = {
      record_expiration = {
        expiration = "ENABLED"
        days       = 30
      }
    }
  }
}

run "plan_modern_bucket_features" {
  command = plan

  assert {
    condition     = aws_s3_bucket_request_payment_configuration.example[0].payer == "Requester"
    error_message = "Requester Pays should be configured when request_payer is set."
  }

  assert {
    condition     = one(one(aws_s3_bucket_server_side_encryption_configuration.example[0].rule).apply_server_side_encryption_by_default).sse_algorithm == "aws:kms" && one(aws_s3_bucket_server_side_encryption_configuration.example[0].rule).bucket_key_enabled
    error_message = "SSE-KMS and the S3 Bucket Key should be passed to the bucket encryption resource."
  }

  assert {
    condition     = aws_s3_bucket_notification.this[0].eventbridge && length(aws_s3_bucket_notification.this[0].lambda_function) == 1 && length(aws_s3_bucket_notification.this[0].queue) == 1 && length(aws_s3_bucket_notification.this[0].topic) == 1
    error_message = "All configured S3 notification destinations should be planned."
  }

  assert {
    condition     = aws_s3_bucket_abac.this[0].abac_status[0].status == "Enabled"
    error_message = "S3 bucket ABAC should be enabled."
  }

  assert {
    condition     = aws_s3_bucket_metadata_configuration.this[0].metadata_configuration[0].inventory_table_configuration[0].configuration_state == "ENABLED"
    error_message = "S3 Metadata inventory table configuration should be planned."
  }

  assert {
    condition     = one(one(aws_s3_bucket_lifecycle_configuration.default[0].rule).noncurrent_version_transition).noncurrent_days == 60 && aws_s3_bucket_lifecycle_configuration.default[0].transition_default_minimum_object_size == "varies_by_storage_class"
    error_message = "Lifecycle Standard-IA noncurrent days and the transition object-size default should be planned independently."
  }
}

run "plan_dsse_kms" {
  command = plan

  variables {
    sse_algorithm      = "aws:kms:dsse"
    bucket_key_enabled = null
  }

  assert {
    condition     = one(one(aws_s3_bucket_server_side_encryption_configuration.example[0].rule).apply_server_side_encryption_by_default).sse_algorithm == "aws:kms:dsse"
    error_message = "Dual-layer KMS encryption should be passed to the bucket encryption resource."
  }
}
