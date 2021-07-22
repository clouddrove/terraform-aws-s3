## Managed By : CloudDrove
# Description : This Script is used to create S3.
## Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.12.0"

  name        = var.name
  application = var.application
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
resource "aws_s3_bucket" "s3_default" {
  count = var.create_bucket && var.bucket_enabled == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = module.labels.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket on AWS
resource "aws_s3_bucket_policy" "s3_default" {
  count = var.create_bucket && var.bucket_policy && var.bucket_enabled == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_default.*.id)
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket resource for launching static
#               website on AWS
resource "aws_s3_bucket" "s3_website" {
  count = var.create_bucket && var.website_hosting_bucket == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  website {
    index_document = var.website_index
    error_document = var.website_error
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = module.labels.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket which is used for
#               static website on AWS
resource "aws_s3_bucket_policy" "s3_website" {
  count = var.create_bucket && var.bucket_policy && var.website_hosting_bucket == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_website.*.id)
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket with logging resource on AWS
resource "aws_s3_bucket" "s3_logging" {
  count = var.create_bucket && var.bucket_logging_enabled == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }
  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }

  tags = module.labels.tags

}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket with logging resource on AWS
resource "aws_s3_bucket" "s3_logging_encryption" {
  count = var.create_bucket && var.bucket_logging_encryption_enabled == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }
  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }
  tags = module.labels.tags

}



# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket logging on AWS
resource "aws_s3_bucket_policy" "s3_logging_encryption" {
  count = var.create_bucket && var.bucket_policy && var.bucket_logging_encryption_enabled == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_logging.*.id)
  policy = var.aws_iam_policy_document
}


# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket logging on AWS
resource "aws_s3_bucket_policy" "s3_logging" {
  count = var.create_bucket && var.bucket_policy && var.bucket_logging_enabled == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_logging.*.id)
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket with encryption resource on AWS
resource "aws_s3_bucket" "s3_encryption" {
  count = var.create_bucket && var.bucket_encryption_enabled == true ? 1 : 0

  bucket        = module.labels.id
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
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

  tags = module.labels.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket encryption on AWS
resource "aws_s3_bucket_policy" "s3_encryption" {
  count = var.create_bucket && var.bucket_policy && var.bucket_encryption_enabled == true ? 1 : 0

  bucket = join("", aws_s3_bucket.s3_encryption.*.id)
  policy = var.aws_iam_policy_document
}
