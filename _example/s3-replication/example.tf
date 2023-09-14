####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "replica"
}

data "aws_caller_identity" "current" {}

locals {
  environment = "test"
  label_order = ["name", "environment"]
}

##----------------------------------------------------------------------------------
## Below resources will create KMS-KEY and its components.
##----------------------------------------------------------------------------------
resource "aws_kms_key" "replica" {
  provider                = aws.replica
  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 7
}

##----------------------------------------------------------------------------------
## Provides details about a replica S3 bucket.
##----------------------------------------------------------------------------------
module "replica_bucket" {
  source = "../../"

  providers = {
    aws = aws.replica
  }
  name        = "clouddrov-s3-replica"
  s3_name     = "antil"
  environment = local.environment
  label_order = local.label_order
  acl         = "private"
  versioning  = true
}
##----------------------------------------------------------------------------------
## Provides details about a specific S3 bucket.
##----------------------------------------------------------------------------------
module "s3_bucket" {
  source = "../../"

  name        = "clouddrov-s3"
  s3_name     = "poxord"
  environment = local.environment
  label_order = local.label_order

  acl = "private"
  replication_configuration = {
    role       = aws_iam_role.replication.arn
    versioning = true

    rules = [
      {
        id                        = "something-with-kms-and-filter"
        status                    = true
        priority                  = 10
        delete_marker_replication = false
        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }
        filter = {
          prefix = "one"
          tags = {
            ReplicateMe = "Yes"
          }
        }
        destination = {
          bucket             = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica.arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }
          replication_time = {
            status  = "Enabled"
            minutes = 15
          }
          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      },
      {
        id                        = "something-with-filter"
        priority                  = 20
        delete_marker_replication = false
        filter = {
          prefix = "two"
          tags = {
            ReplicateMe = "Yes"
          }
        }
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
      {
        id                        = "everything-with-filter"
        status                    = "Enabled"
        priority                  = 30
        delete_marker_replication = true
        1 = {
          prefix = ""
        }
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
      {
        id                        = "everything-without-filters"
        status                    = "Enabled"
        delete_marker_replication = true
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
    ]
  }
}

##----------------------------------------------------------------------------------
## Provides an IAM role.
##----------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  name = "s3-bucket-replication-${module.replica_bucket.id}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

##----------------------------------------------------------------------------------
## Generates an IAM policy in JSON format for use with resources that expect policy documents such as aws_iam_policy.
##----------------------------------------------------------------------------------
resource "aws_iam_policy" "replication" {
  name = "s3-bucket-replication-${module.replica_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${module.s3_bucket.id}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${module.s3_bucket.id}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${module.replica_bucket.id}/*"
    }
  ]
}
POLICY
}

##----------------------------------------------------------------------------------
## Attaches a Managed IAM Policy to user(s), role(s), and/or group(s).
##----------------------------------------------------------------------------------
resource "aws_iam_policy_attachment" "replication" {
  name       = "s3-bucket-replication-${module.replica_bucket.id}"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}
