##----------------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##----------------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "1.3.0"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##----------------------------------------------------------------------------------
## Terraform resource to create S3 bucket with different combination type specific features.
##----------------------------------------------------------------------------------
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "s3_default" {
  count = var.enabled == true ? 1 : 0

  bucket              = var.s3_name != null ? var.s3_name : module.labels.id
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = module.labels.tags
}

##----------------------------------------------------------------------------------
## Terraform resource which creates policy for S3 bucket on AWS.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "s3_default" {
  count  = var.bucket_policy == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default[*].id)
  policy = var.aws_iam_policy_document

  depends_on = [
    aws_s3_bucket.s3_default
  ]
}

resource "aws_s3_bucket_policy" "block-http" {
  count  = var.enabled && var.only_https_traffic ? 1 : 0
  bucket = aws_s3_bucket.s3_default[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Blockhttp"
    Statement = [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          aws_s3_bucket.s3_default[0].arn,
          "${aws_s3_bucket.s3_default[0].arn}/*",
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      },
    ]
  })
}
##----------------------------------------------------------------------------------
## Provides an S3 bucket accelerate configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_accelerate_configuration" "example" {
  count                 = var.enabled && var.acceleration_status == true ? 1 : 0
  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner
  status                = var.configuration_status
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket request payment configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_request_payment_configuration" "example" {
  count = var.enabled && var.request_payer == true ? 1 : 0

  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner
  payer                 = lower(var.request_payer) == "requester" ? "Requester" : "BucketOwner"
}

##----------------------------------------------------------------------------------
## Provides a resource for controlling versioning on an S3 bucket.
## Deleting this resource will either suspend versioning on the associated S3 bucket or simply remove the resource from Terraform state if the associated S3 bucket is unversioned.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "example" {
  count = var.enabled && var.versioning == true ? 1 : 0

  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner
  mfa                   = var.mfa
  versioning_configuration {
    status     = var.versioning_status
    mfa_delete = var.mfa_delete
  }
}

##----------------------------------------------------------------------------------
## Provides an S3 bucket (server access) logging resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_logging" "example" {
  count  = var.enabled && var.logging == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default[*].id)

  target_bucket = var.target_bucket
  target_prefix = var.target_prefix
}

##----------------------------------------------------------------------------------
## Provides a S3 bucket server-side encryption configuration resource.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count                 = var.enabled && var.enable_server_side_encryption == true ? 1 : 0
  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner

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
  count = var.enabled && var.object_lock_enabled && var.object_lock_configuration != null ? 1 : 0

  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner
  token                 = try(var.object_lock_configuration.token, null)

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
  count = var.enabled && var.cors_rule != null ? 1 : 0

  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = var.cors_rule == null ? [] : var.cors_rule

    content {
      id              = try(cors_rule.value.id, null)
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
resource "aws_s3_bucket_website_configuration" "this" {
  count = var.enabled && length(keys(var.website)) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.s3_default[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website["error_document"]], [])

    content {
      key = error_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try([var.website["redirect_all_requests_to"]], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = try(flatten([var.website["routing_rules"]]), [])

    content {
      dynamic "condition" {
        for_each = [try([routing_rule.value.condition], [])]

        content {
          http_error_code_returned_equals = try(routing_rule.value.condition["http_error_code_returned_equals"], null)
          key_prefix_equals               = try(routing_rule.value.condition["key_prefix_equals"], null)
        }
      }

      redirect {
        host_name               = try(routing_rule.value.redirect["host_name"], null)
        http_redirect_code      = try(routing_rule.value.redirect["http_redirect_code"], null)
        protocol                = try(routing_rule.value.redirect["protocol"], null)
        replace_key_prefix_with = try(routing_rule.value.redirect["replace_key_prefix_with"], null)
        replace_key_with        = try(routing_rule.value.redirect["replace_key_with"], null)
      }
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
  count                 = var.enabled ? var.grants != null ? var.acl != null ? 1 : 0 : 0 : 0
  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner

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
        id           = var.owner_id
        display_name = try(var.owner["display_name"], null)

      }
    }
  }
}

##----------------------------------------------------------------------------------
## Provides an independent configuration resource for S3 bucket lifecycle configuration.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "default" {
  count                 = var.enabled && var.enable_lifecycle_configuration_rules == true ? 1 : 0
  bucket                = join("", aws_s3_bucket.s3_default[*].id)
  expected_bucket_owner = var.expected_bucket_owner

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
          newer_noncurrent_versions = rule.value.noncurrent_version_expiration_days
          noncurrent_days           = rule.value.noncurrent_version_expiration_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.enable_glacier_transition ? [1] : []

        content {
          newer_noncurrent_versions = rule.value.noncurrent_version_glacier_transition_newer
          noncurrent_days           = rule.value.noncurrent_version_glacier_transition_days
          storage_class             = rule.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.enable_deeparchive_transition ? [1] : []

        content {
          newer_noncurrent_versions = rule.value.noncurrent_version_glacier_transition_newer
          noncurrent_days           = rule.value.noncurrent_version_deeparchive_transition_days
          storage_class             = rule.value.storage_class
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_glacier_transition ? [1] : []

        content {
          date          = rule.value.glacier_transition_date
          days          = rule.value.glacier_transition_days
          storage_class = rule.value.storage_class
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_deeparchive_transition ? [1] : []

        content {
          date          = rule.value.glacier_transition_date
          days          = rule.value.deeparchive_transition_days
          storage_class = rule.value.storage_class
        }
      }

      dynamic "transition" {
        for_each = rule.value.enable_standard_ia_transition ? [1] : []

        content {
          date          = rule.value.glacier_transition_date
          days          = rule.value.standard_transition_days
          storage_class = rule.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.enable_current_object_expiration ? [1] : []

        content {
          days                         = rule.value.expiration_days
          date                         = try(expiration.value.date, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
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
  count = var.enabled && length(keys(var.replication_configuration)) > 0 ? 1 : 0

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

##----------------------------------------------------------------------------------
## Manages S3 bucket-level Public Access Block configuration.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.enabled && var.attach_public_policy ? 1 : 0
  bucket                  = aws_s3_bucket.s3_default[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

##----------------------------------------------------------------------------------
## Provides a resource to manage S3 Bucket Ownership Controls.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "this" {
  count = var.enabled && var.control_object_ownership ? 1 : 0

  bucket = aws_s3_bucket.s3_default[0].id

  rule {
    object_ownership = var.object_ownership
  }

  # This `depends_on` is to prevent "A conflicting conditional operation is currently in progress against this resource."
  depends_on = [
    aws_s3_bucket_policy.s3_default,
    aws_s3_bucket.s3_default
  ]
}

##----------------------------------------------------------------------------------
## Tiering automatically stores objects in three access tiers: one tier optimized for frequent access, a lower-cost tier optimized for infrequent access, and a very-low-cost tier optimized for rarely accessed data.
##----------------------------------------------------------------------------------
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  for_each = { for k, v in var.intelligent_tiering : k => v if var.enabled }

  name   = module.labels.id
  bucket = aws_s3_bucket.s3_default[0].id
  status = try(tobool(each.value.status) ? "Enabled" : "Disabled", title(lower(each.value.status)), null)

  # Max 1 block - filter
  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = each.value.tiering

    content {
      access_tier = tiering.key
      days        = tiering.value.days
    }
  }
}

resource "aws_s3_bucket_metric" "this" {
  for_each = { for k, v in var.metric_configuration : k => v if var.enabled }

  name   = module.labels.id
  bucket = aws_s3_bucket.s3_default[0].id

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]
    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }
}

resource "aws_s3_bucket_inventory" "this" {
  for_each = { for k, v in var.inventory_configuration : k => v if var.enabled }

  name                     = module.labels.id
  bucket                   = aws_s3_bucket.s3_default[0].id
  included_object_versions = each.value.included_object_versions
  enabled                  = try(each.value.enabled, true)
  optional_fields          = try(each.value.optional_fields, null)

  destination {
    bucket {
      bucket_arn = try(each.value.destination.bucket_arn, aws_s3_bucket.s3_default[0].arn)
      format     = try(each.value.destination.format, null)
      account_id = try(each.value.destination.account_id, null)
      prefix     = try(each.value.destination.prefix, null)

      dynamic "encryption" {
        for_each = length(try(flatten([each.value.destination.encryption]), [])) == 0 ? [] : [true]

        content {

          dynamic "sse_kms" {
            for_each = each.value.destination.encryption.encryption_type == "sse_kms" ? [true] : []

            content {
              key_id = try(each.value.destination.encryption.kms_key_id, null)
            }
          }

          dynamic "sse_s3" {
            for_each = each.value.destination.encryption.encryption_type == "sse_s3" ? [true] : []

            content {
            }
          }
        }
      }
    }
  }

  schedule {
    frequency = each.value.frequency
  }

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(each.value.filter.prefix, null)
    }
  }
}

resource "aws_s3_bucket_analytics_configuration" "default" {
  for_each = { for k, v in var.analytics_configuration : k => v if var.enabled }

  bucket = aws_s3_bucket.s3_default[0].id
  name   = each.key

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }

  dynamic "storage_class_analysis" {
    for_each = length(try(flatten([each.value.storage_class_analysis]), [])) == 0 ? [] : [true]

    content {

      data_export {
        output_schema_version = try(each.value.storage_class_analysis.output_schema_version, null)

        destination {

          s3_bucket_destination {
            bucket_arn        = try(each.value.storage_class_analysis.destination_bucket_arn, aws_s3_bucket.s3_default[0].arn)
            bucket_account_id = try(each.value.storage_class_analysis.destination_account_id, var.aws_iam_policy_document)
            format            = try(each.value.storage_class_analysis.export_format, "CSV")
            prefix            = try(each.value.storage_class_analysis.export_prefix, null)
          }
        }
      }
    }
  }
}

##----------------------------------------------------------------------------------
## VPC Endpoint resource for S3.
##----------------------------------------------------------------------------------
data "aws_vpc_endpoint_service" "s3" {
  for_each     = { for ep in var.vpc_endpoints : ep.endpoint_count => ep }
  service      = "s3"
  service_type = each.value.service_type
}

resource "aws_vpc_endpoint" "endpoints" {
  for_each = { for ep in var.vpc_endpoints : ep.endpoint_count => ep }

  vpc_id            = each.value.vpc_id
  service_name      = data.aws_vpc_endpoint_service.s3[each.key].service_name
  vpc_endpoint_type = each.value.service_type
  auto_accept       = lookup(each.value, "auto_accept", null)

  security_group_ids  = lookup(each.value, "service_type", "Interface") == "Interface" ? length(distinct(lookup(each.value, "security_group_ids", []))) > 0 ? lookup(each.value, "security_group_ids", []) : null : null
  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(lookup(each.value, "subnet_ids", []))) : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? lookup(each.value, "route_table_ids", null) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? try(each.value.private_dns_enabled, null) : null

  tags = merge(module.labels.tags,
    {
      "Name" = format("%s-%s-%s", module.labels.id, "ep", each.value.endpoint_count)
    }
  )

  timeouts {
    create = try(var.timeouts.create, "10m")
    update = try(var.timeouts.update, "10m")
    delete = try(var.timeouts.delete, "10m")
  }
}