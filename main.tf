## Managed By : CloudDrove
# Description : This Script is used to create S3.
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.15.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
resource "aws_s3_bucket" "s3_default" {
  count = var.create_bucket == true ? 1 : 0

  bucket        = module.labels.id
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy
  acl           = try(length(var.acl),0) == 0 ? var.acl : null
  acceleration_status = var.acceleration_status

  versioning {
    enabled    = var.versioning
    mfa_delete = var.mfa_delete
  }
  
  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document          = lookup(website.value,"index_document",null)
      error_document          = lookup(website.value,"error_document",null)
      redirect_all_requests_to = lookup(website.value,"redirect_all_requests_to",null)
      routing_rules           = lookup(website.value,"routing_rules",null)
    }
  }

  dynamic "logging" {
    for_each = length (keys(var.logging)) == 0 ? [] : [var.logging]

    content {
    target_bucket = logging.value.target_bucket
    target_prefix = lookup(logging.value,"target_prefix",null)
    }
  }

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }

  dynamic "grant" {
    for_each = try(length(var.grants),0) == 0 || try(length(var.acl),0) > 0 ? [] : var.grants
    content {
      id = grant.value.id
      type = grant.value.type
      permissions = grant.value.permissions
      uri = grant.value.uri
    }
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled
    prefix  = var.lifecycle_infrequent_storage_object_prefix
    tags    = module.labels.tags

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled
    prefix  = var.lifecycle_glacier_object_prefix
    tags    = module.labels.tags


    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

   lifecycle_rule {
    id      = "transition-to-deep-archive"
    enabled = var.lifecycle_deep_archive_transition_enabled
    prefix  = var.lifecycle_deep_archive_object_prefix
    tags    = module.labels.tags


    transition {
      days          = var.lifecycle_days_to_deep_archive_transition
      storage_class = "DEEP_ARCHIVE"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled
    prefix  = var.lifecycle_expiration_object_prefix
    tags    = module.labels.tags


    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = module.labels.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket on AWS
resource "aws_s3_bucket_policy" "s3_default" {
  # count = var.create_bucket && var.bucket_policy && var.bucket_enabled == true ? 1 : 0
  count =  var.bucket_policy  == true ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_default.*.id)
  policy = var.aws_iam_policy_document
}

# # Module      : S3 BUCKET
# # Description : Terraform module which creates S3 bucket resource for launching static
# #               website on AWS
# resource "aws_s3_bucket" "s3_website" {
#   count = var.create_bucket && var.website_hosting_bucket == true ? 1 : 0

#   bucket        = module.labels.id
#   force_destroy = var.force_destroy
#   acl           = var.acl

#   versioning {
#     enabled    = var.versioning
#     mfa_delete = var.mfa_delete
#   }

#   website {
#     index_document = var.website_index
#     error_document = var.website_error
#   }

#   lifecycle_rule {
#     id      = "transition-to-infrequent-access-storage"
#     enabled = var.lifecycle_infrequent_storage_transition_enabled

#     prefix = var.lifecycle_infrequent_storage_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_infrequent_storage_transition
#       storage_class = "STANDARD_IA"
#     }
#   }

#   lifecycle_rule {
#     id      = "transition-to-glacier"
#     enabled = var.lifecycle_glacier_transition_enabled

#     prefix = var.lifecycle_glacier_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_glacier_transition
#       storage_class = "GLACIER"
#     }
#   }

#   lifecycle_rule {
#     id      = "expire-objects"
#     enabled = var.lifecycle_expiration_enabled

#     prefix = var.lifecycle_expiration_object_prefix

#     expiration {
#       days = var.lifecycle_days_to_expiration
#     }
#   }

#   tags = module.labels.tags

# }

# # Module      : S3 BUCKET POLICY
# # Description : Terraform module which creates policy for S3 bucket which is used for
# #               static website on AWS
# resource "aws_s3_bucket_policy" "s3_website" {
#   count = var.create_bucket && var.bucket_policy && var.website_hosting_bucket == true ? 1 : 0

#   bucket = join("", aws_s3_bucket.s3_website.*.id)
#   policy = var.aws_iam_policy_document
# }

# # Module      : S3 BUCKET
# # Description : Terraform module which creates S3 bucket with logging resource on AWS
# resource "aws_s3_bucket" "s3_logging" {
#   count = var.create_bucket && var.bucket_logging_enabled == true ? 1 : 0

#   bucket        = module.labels.id
#   force_destroy = var.force_destroy
#   acl           = var.acl

#   versioning {
#     enabled    = var.versioning
#     mfa_delete = var.mfa_delete
#   }

#   lifecycle_rule {
#     id      = "transition-to-infrequent-access-storage"
#     enabled = var.lifecycle_infrequent_storage_transition_enabled

#     prefix = var.lifecycle_infrequent_storage_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_infrequent_storage_transition
#       storage_class = "STANDARD_IA"
#     }
#   }

#   lifecycle_rule {
#     id      = "transition-to-glacier"
#     enabled = var.lifecycle_glacier_transition_enabled

#     prefix = var.lifecycle_glacier_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_glacier_transition
#       storage_class = "GLACIER"
#     }
#   }

#   lifecycle_rule {
#     id      = "expire-objects"
#     enabled = var.lifecycle_expiration_enabled

#     prefix = var.lifecycle_expiration_object_prefix

#     expiration {
#       days = var.lifecycle_days_to_expiration
#     }
#   }
#   logging {
#     target_bucket = var.target_bucket
#     target_prefix = var.target_prefix
#   }

#   tags = module.labels.tags

# }

# # Module      : S3 BUCKET
# # Description : Terraform module which creates S3 bucket with logging resource on AWS
# resource "aws_s3_bucket" "s3_logging_encryption" {
#   count = var.create_bucket && var.bucket_logging_encryption_enabled == true ? 1 : 0

#   bucket        = module.labels.id
#   force_destroy = var.force_destroy
#   acl           = var.acl

#   versioning {
#     enabled    = var.versioning
#     mfa_delete = var.mfa_delete
#   }

#   lifecycle_rule {
#     id      = "transition-to-infrequent-access-storage"
#     enabled = var.lifecycle_infrequent_storage_transition_enabled

#     prefix = var.lifecycle_infrequent_storage_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_infrequent_storage_transition
#       storage_class = "STANDARD_IA"
#     }
#   }

#   lifecycle_rule {
#     id      = "transition-to-glacier"
#     enabled = var.lifecycle_glacier_transition_enabled

#     prefix = var.lifecycle_glacier_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_glacier_transition
#       storage_class = "GLACIER"
#     }
#   }

#   lifecycle_rule {
#     id      = "expire-objects"
#     enabled = var.lifecycle_expiration_enabled

#     prefix = var.lifecycle_expiration_object_prefix

#     expiration {
#       days = var.lifecycle_days_to_expiration
#     }
#   }
#   logging {
#     target_bucket = var.target_bucket
#     target_prefix = var.target_prefix
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm     = var.sse_algorithm
#         kms_master_key_id = var.kms_master_key_id
#       }
#     }
#   }
#   tags = module.labels.tags

# }



# # Module      : S3 BUCKET POLICY
# # Description : Terraform module which creates policy for S3 bucket logging on AWS
# resource "aws_s3_bucket_policy" "s3_logging_encryption" {
#   count = var.create_bucket && var.bucket_policy && var.bucket_logging_encryption_enabled == true ? 1 : 0

#   bucket = join("", aws_s3_bucket.s3_logging.*.id)
#   policy = var.aws_iam_policy_document
# }


# # Module      : S3 BUCKET POLICY
# # Description : Terraform module which creates policy for S3 bucket logging on AWS
# resource "aws_s3_bucket_policy" "s3_logging" {
#   count = var.create_bucket && var.bucket_policy && var.bucket_logging_enabled == true ? 1 : 0

#   bucket = join("", aws_s3_bucket.s3_logging.*.id)
#   policy = var.aws_iam_policy_document
# }

# # Module      : S3 BUCKET
# # Description : Terraform module which creates S3 bucket with encryption resource on AWS
# resource "aws_s3_bucket" "s3_encryption" {
#   count = var.create_bucket && var.bucket_encryption_enabled == true ? 1 : 0

#   bucket        = module.labels.id
#   force_destroy = var.force_destroy
#   acl           = var.acl

#   versioning {
#     enabled    = var.versioning
#     mfa_delete = var.mfa_delete
#   }

#   lifecycle_rule {
#     id      = "transition-to-infrequent-access-storage"
#     enabled = var.lifecycle_infrequent_storage_transition_enabled

#     prefix = var.lifecycle_infrequent_storage_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_infrequent_storage_transition
#       storage_class = "STANDARD_IA"
#     }
#   }

#   lifecycle_rule {
#     id      = "transition-to-glacier"
#     enabled = var.lifecycle_glacier_transition_enabled

#     prefix = var.lifecycle_glacier_object_prefix

#     transition {
#       days          = var.lifecycle_days_to_glacier_transition
#       storage_class = "GLACIER"
#     }
#   }

#   lifecycle_rule {
#     id      = "expire-objects"
#     enabled = var.lifecycle_expiration_enabled

#     prefix = var.lifecycle_expiration_object_prefix

#     expiration {
#       days = var.lifecycle_days_to_expiration
#     }
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm     = var.sse_algorithm
#         kms_master_key_id = var.kms_master_key_id
#       }
#     }
#   }

#   tags = module.labels.tags

# }

# # Module      : S3 BUCKET POLICY
# # Description : Terraform module which creates policy for S3 bucket encryption on AWS
# resource "aws_s3_bucket_policy" "s3_encryption" {
#   count = var.create_bucket && var.bucket_policy && var.bucket_encryption_enabled == true ? 1 : 0

#   bucket = join("", aws_s3_bucket.s3_encryption.*.id)
#   policy = var.aws_iam_policy_document
# }
