mock_provider "aws" {}

run "default_bucket" {
  command = plan

  variables {
    name        = "example"
    environment = "test"
  }

  assert {
    condition     = length(aws_s3_bucket.s3_default) == 1
    error_message = "The default configuration must create one bucket."
  }

  assert {
    condition     = length(aws_s3_bucket_policy.s3_default) == 1
    error_message = "HTTPS-only enforcement must use the single combined bucket policy."
  }
}

run "disabled_module" {
  command = plan

  variables {
    enabled       = false
    bucket_policy = true
    vpc_endpoints = [{
      endpoint_count = 1
      vpc_id         = "vpc-12345678"
      service_type   = "Gateway"
    }]
  }

  assert {
    condition     = length(aws_s3_bucket.s3_default) == 0
    error_message = "enabled=false must disable bucket resources."
  }

  assert {
    condition     = length(aws_s3_bucket_policy.s3_default) == 0 && length(aws_vpc_endpoint.endpoints) == 0
    error_message = "enabled=false must also disable policies and VPC endpoints."
  }
}

run "requester_pays_and_acl" {
  command = plan

  variables {
    name             = "requester"
    request_payer    = "Requester"
    acl              = "private"
    object_ownership = "BucketOwnerPreferred"
  }

  assert {
    condition     = length(aws_s3_bucket_request_payment_configuration.example) == 1
    error_message = "Requester Pays must be created when request_payer is configured."
  }

  assert {
    condition     = length(aws_s3_bucket_acl.default) == 1
    error_message = "A canned ACL must create an ACL resource."
  }
}

run "bucket_prefix" {
  command = plan

  variables {
    bucket_prefix = "module-test-"
  }

  assert {
    condition     = aws_s3_bucket.s3_default[0].bucket_prefix == "module-test-"
    error_message = "bucket_prefix must be passed to the bucket resource."
  }
}

run "replication_filter" {
  command = plan

  variables {
    name = "replication"
    replication_configuration = {
      role = "arn:aws:iam::123456789012:role/s3-replication"
      rules = [{
        id       = "documents"
        priority = 10
        status   = "Enabled"
        filter   = { prefix = "documents/" }
        destination = {
          bucket = "arn:aws:s3:::destination-bucket"
        }
        }, {
        id       = "all-objects"
        priority = 20
        status   = "Enabled"
        destination = {
          bucket = "arn:aws:s3:::destination-bucket"
        }
      }]
    }
  }

  assert {
    condition     = length(aws_s3_bucket_replication_configuration.this) == 1
    error_message = "A replication configuration with one filter must produce a valid resource."
  }
}

run "lifecycle_rule" {
  command = plan

  variables {
    name                                 = "lifecycle"
    enable_lifecycle_configuration_rules = true
    lifecycle_configuration_rules = [
      {
        id = "documents"
        filter = {
          prefix                   = "documents/"
          object_size_greater_than = 128
        }
        enable_current_object_expiration                 = true
        expiration_days                                  = 30
        enable_noncurrent_version_standard_ia_transition = true
        noncurrent_version_standard_ia_transition_days   = 60
      },
      {
        id = "empty-filter"
        filter = {
          prefix = null
          tags   = {}
        }
        abort_incomplete_multipart_upload_days = 7
      }
    ]
  }

  assert {
    condition     = length(aws_s3_bucket_lifecycle_configuration.default) == 1
    error_message = "A multi-attribute lifecycle filter must produce one valid lifecycle configuration."
  }
}

run "modern_bucket_features" {
  command = plan

  variables {
    name                     = "modern"
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
    }
  }

  assert {
    condition = (
      length(aws_s3_bucket_notification.this) == 1 &&
      length(aws_s3_bucket_abac.this) == 1 &&
      length(aws_s3_bucket_metadata_configuration.this) == 1
    )
    error_message = "Notifications, ABAC, and S3 Metadata must be created when configured."
  }
}
