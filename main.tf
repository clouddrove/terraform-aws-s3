##----------------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##----------------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"


  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}
##----------------------------------------------------------------------------------
## Terraform resource to create S3 bucket with different combination type specific features.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket" "s3_default" {
  count = var.create_bucket == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  tags          = module.labels.tags

  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration != null ? [1] : []

    content {
      object_lock_enabled = "Enabled"
    }
  }
}

##----------------------------------------------------------------------------------
## Terraform resource which creates policy for S3 bucket on AWS.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "s3_default" {
  count  = var.bucket_policy == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)
  policy = var.aws_iam_policy_document
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket accelerate configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_accelerate_configuration" "example" {
  count = var.create_bucket && var.acceleration_status == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  status = "Enabled"
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket request payment configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_request_payment_configuration" "example" {
  count = var.create_bucket && var.request_payer == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  payer  = "Requester"
}

##----------------------------------------------------------------------------------
## Provides a resource for controlling versioning on an S3 bucket.
## Deleting this resource will either suspend versioning on the associated S3 bucket or simply remove the resource from Terraform state if the associated S3 bucket is unversioned.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "example" {
  count = var.create_bucket && var.versioning == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  versioning_configuration {
    status = "Enabled"
  }
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket (server access) logging resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_logging" "example" {
  count  = var.create_bucket && var.logging == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)

  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
}

##----------------------------------------------------------------------------------
## Provides a S3 bucket server-side encryption configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count  = var.create_bucket && var.enable_server_side_encryption == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.enable_kms == true ? "aws:kms" : var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket Object Lock configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_object_lock_configuration" "example" {
  count = var.create_bucket && var.object_lock_configuration != null ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)

  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode  = var.object_lock_configuration.mode
      days  = var.object_lock_configuration.days
      years = var.object_lock_configuration.years
    }
  }
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket CORS configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_cors_configuration" "example" {
  count = var.create_bucket && var.cors_rule != null ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)

  dynamic "cors_rule" {
    for_each = var.cors_rule == null ? [] : var.cors_rule

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket website configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_website_configuration" "example" {
  count = var.create_bucket && var.website_config_enable == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

locals {
  acl_grants = var.grants == null ? var.acl_grants : flatten(
    [
      for g in var.grants : [
        for p in g.permissions : {
          id         = g.id
          type       = g.type
          permission = p
          uri        = g.uri
        }
      ]
  ])
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket ACL resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_acl" "default" {

  count  = var.create_bucket ? var.grants != null ? var.acl != null ? 1 : 0 : 0 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)


  acl = try(length(local.acl_grants), 0) == 0 ? var.acl : null

  dynamic "access_control_policy" {
    for_each = try(length(local.acl_grants), 0) == 0 || try(length(var.acl), 0) > 0 ? [] : [1]

    content {
      dynamic "grant" {
        for_each = local.acl_grants

        content {
          grantee {
            id   = grant.value.id
            type = grant.value.type
            uri  = grant.value.uri
          }
          permission = grant.value.permission
        }
      }

      owner {
        id = var.owner_id
      }
    }
  }
}

##----------------------------------------------------------------------------------
## Provides an independent configuration resource for S3 bucket lifecycle configuration.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "default" {
  count  = var.create_bucket && var.enable_lifecycle_configuration_rules == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)

  dynamic "rule" {
    for_each = var.lifecycle_configuration_rules

    content {
      id     = rule.value.id
      status = rule.value.enabled == true ? "Enabled" : "Disabled"

      # Filter is always required due to https://github.com/hashicorp/terraform-provider-aws/issues/23299
      filter {
        dynamic "and" {
          for_each = (try(length(rule.value.prefix), 0) + try(length(rule.value.tags), 0)) > 0 ? [1] : []
          content {
            prefix = rule.value.prefix == null ? "" : rule.value.prefix
            tags   = try(length(rule.value.tags), 0) > 0 ? rule.value.tags : {}
          }
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try(tonumber(rule.value.abort_incomplete_multipart_upload_days), null) != null ? [1] : []
        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.enable_noncurrent_version_expiration ? [1] : []

        content {
          noncurrent_days = rule.value.noncurrent_version_expiration_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.enable_glacier_transition ? [1] : []

        content {
          noncurrent_days = rule.value.noncurrent_version_glacier_transition_days
          storage_class   = "GLACIER"
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.enable_deeparchive_transition ? [1] : []

        content {
          noncurrent_days = rule.value.noncurrent_version_deeparchive_transition_days
          storage_class   = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_glacier_transition ? [1] : []

        content {
          days          = rule.value.glacier_transition_days
          storage_class = "GLACIER"
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_deeparchive_transition ? [1] : []

        content {
          days          = rule.value.deeparchive_transition_days
          storage_class = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_standard_ia_transition ? [1] : []

        content {
          days          = rule.value.standard_transition_days
          storage_class = "STANDARD_IA"
        }
      }

      dynamic "expiration" {
        for_each = rule.value.enable_current_object_expiration ? [1] : []

        content {
          days = rule.value.expiration_days
        }
      }
    }
  }

  depends_on = [
    # versioning must be set before lifecycle configuration
    aws_s3_bucket_versioning.example
  ]
}

##----------------------------------------------------------------------------------
## Provides an independent configuration resource for S3 bucket replication configuration.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_replication_configuration" "this" {
  count = var.create_bucket && length(keys(var.replication_configuration)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.s3_default[0].id
  role   = var.replication_configuration["role"]

  dynamic "rule" {
    for_each = flatten(try([var.replication_configuration["rule"]], [var.replication_configuration["rules"]], []))

    content {
      id       = try(rule.value.id, null)
      priority = try(rule.value.priority, null)
      prefix   = try(rule.value.prefix, null)
      status   = try(tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)), "Enabled")

      dynamic "delete_marker_replication" {
        for_each = flatten(try([rule.value.delete_marker_replication_status], [rule.value.delete_marker_replication], []))

        content {
          # Valid values: "Enabled" or "Disabled"
          status = try(tobool(delete_marker_replication.value) ? "Enabled" : "Disabled", title(lower(delete_marker_replication.value)))
        }
      }

      # Amazon S3 does not support this argument according to:
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration
      # More infor about what does Amazon S3 replicate?
      # https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-what-is-isnot-replicated.html
      dynamic "existing_object_replication" {
        for_each = flatten(try([rule.value.existing_object_replication_status], [rule.value.existing_object_replication], []))

        content {
          # Valid values: "Enabled" or "Disabled"
          status = try(tobool(existing_object_replication.value) ? "Enabled" : "Disabled", title(lower(existing_object_replication.value)))
        }
      }

      dynamic "destination" {
        for_each = try(flatten([rule.value.destination]), [])

        content {
          bucket        = destination.value.bucket
          storage_class = try(destination.value.storage_class, null)
          account       = try(destination.value.account_id, destination.value.account, null)

          dynamic "access_control_translation" {
            for_each = try(flatten([destination.value.access_control_translation]), [])

            content {
              owner = title(lower(access_control_translation.value.owner))
            }
          }

          dynamic "encryption_configuration" {
            for_each = flatten([try(destination.value.encryption_configuration.replica_kms_key_id, destination.value.replica_kms_key_id, [])])

            content {
              replica_kms_key_id = encryption_configuration.value
            }
          }

          dynamic "replication_time" {
            for_each = try(flatten([destination.value.replication_time]), [])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(replication_time.value.status) ? "Enabled" : "Disabled", title(lower(replication_time.value.status)), "Disabled")

              dynamic "time" {
                for_each = try(flatten([replication_time.value.minutes]), [])

                content {
                  minutes = replication_time.value.minutes
                }
              }
            }

          }

          dynamic "metrics" {
            for_each = try(flatten([destination.value.metrics]), [])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(metrics.value.status) ? "Enabled" : "Disabled", title(lower(metrics.value.status)), "Disabled")

              dynamic "event_threshold" {
                for_each = try(flatten([metrics.value.minutes]), [])

                content {
                  minutes = metrics.value.minutes
                }
              }
            }
          }
        }
      }

      dynamic "source_selection_criteria" {
        for_each = try(flatten([rule.value.source_selection_criteria]), [])

        content {
          dynamic "replica_modifications" {
            for_each = flatten([try(source_selection_criteria.value.replica_modifications.enabled, source_selection_criteria.value.replica_modifications.status, [])])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(replica_modifications.value) ? "Enabled" : "Disabled", title(lower(replica_modifications.value)), "Disabled")
            }
          }

          dynamic "sse_kms_encrypted_objects" {
            for_each = flatten([try(source_selection_criteria.value.sse_kms_encrypted_objects.enabled, source_selection_criteria.value.sse_kms_encrypted_objects.status, [])])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(sse_kms_encrypted_objects.value) ? "Enabled" : "Disabled", title(lower(sse_kms_encrypted_objects.value)), "Disabled")
            }
          }
        }
      }

      # Max 1 block - filter - without any key arguments or tags
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {
        }
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          prefix = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            prefix = try(filter.value.prefix, null)
            tags   = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.example]
}

locals {
  attach_policy = var.attach_require_latest_tls_policy || var.attach_elb_log_delivery_policy || var.attach_lb_log_delivery_policy || var.attach_deny_insecure_transport_policy || var.attach_policy

}

##----------------------------------------------------------------------------------
## Manages S3 bucket-level Public Access Block configuration.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create_bucket && var.attach_public_policy ? 1 : 0

  bucket = local.attach_policy ? aws_s3_bucket_policy.s3_default[0].id : aws_s3_bucket.s3_default[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

##----------------------------------------------------------------------------------
## Provides a resource to manage S3 Bucket Ownership Controls.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "this" {
  count = var.create_bucket && var.control_object_ownership ? 1 : 0

  bucket = local.attach_policy ? aws_s3_bucket_policy.s3_default[0].id : aws_s3_bucket.s3_default[0].id

  rule {
    object_ownership = var.object_ownership
  }

  # This `depends_on` is to prevent "A conflicting conditional operation is currently in progress against this resource."
  depends_on = [
    aws_s3_bucket_policy.s3_default,
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket.s3_default
  ]
}