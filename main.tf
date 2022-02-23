## Managed By : CloudDrove
# Description : This Script is used to create S3.
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"


  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

# Module      : S3 BUCKET
# Description : Terraform module to create S3 bucket with different combination
#               type specific features.
resource "aws_s3_bucket" "s3_default" {
  count = var.create_bucket == true ? 1 : 0

  bucket        = module.labels.id
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy

  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration != null ? [1] : []

    content {
      object_lock_enabled = "Enabled"

    }
  }
}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket on AWS
resource "aws_s3_bucket_policy" "s3_default" {
  # count = var.create_bucket && var.bucket_policy && var.bucket_enabled == true ? 1 : 0
  count  = var.bucket_policy == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)
  policy = var.aws_iam_policy_document
}

resource "aws_s3_bucket_accelerate_configuration" "example" {
  count = var.create_bucket && var.acceleration_status == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  status = "Enabled"
}

resource "aws_s3_bucket_request_payment_configuration" "example" {
  count = var.create_bucket && var.request_payer == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  payer  = "Requester"
}

resource "aws_s3_bucket_versioning" "example" {
  count = var.create_bucket && var.versioning == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "example" {
  count  = var.create_bucket && var.logging == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)

  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
}

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

# resource "aws_s3_bucket_website_configuration" "example" {
#   for_each = var.create_bucket && var.website_inputs != null ? toset(var.website_inputs) : toset([])

#   bucket = join("", aws_s3_bucket.s3_default.*.id)

#   index_document {
#     suffix = each.value.index_document
#   }

#   error_document {
#     key = each.value.error_document
#   }

#   redirect_all_requests_to {
#     host_name = each.value.redirect_all_requests_to
#     protocol  = each.value.protocol
#   }

#   dynamic "routing_rule" {
#     for_each = length(jsondecode(each.value.routing_rules)) > 0 ? jsondecode(each.value.routing_rules) : []
#     content {
#       dynamic "condition" {
#         for_each = routing_rule.value["Condition"]

#         content {
#           key_prefix_equals = lookup(condition.value, "KeyPrefixEquals")
#         }
#       }

#       dynamic "redirect" {
#         for_each = routing_rule.value["Redirect"]
#         content {
#           replace_key_prefix_with = lookup(redirect.value, "ReplaceKeyPrefixWith")
#         }
#       }
#     }
#   }
# }

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

