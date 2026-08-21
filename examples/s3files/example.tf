provider "aws" {
  region = local.region
}

locals {
  name        = "app"
  environment = "test"
  region      = "us-east-1"

  label_order = ["environment", "name"]

}

##-----------------------------------------------------------------------------
## Vpc Module call.
##-----------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.3"

  enable      = true
  name        = local.name
  environment = local.environment

  cidr_block = "10.0.0.0/16"
}


##-----------------------------------------------------------------------------
## Subnet Module call.
## Below module will deploy both public and private subnets.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-no-excessive-port-access
#tfsec:ignore:aws-ec2-no-public-ingress-acl
module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.2"

  enable      = true
  name        = local.name
  environment = local.environment

  nat_gateway_enabled = true
  single_nat_gateway  = true
  availability_zones  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  vpc_id              = module.vpc.vpc_id
  cidr_block          = module.vpc.vpc_cidr_block
  type                = "public-private"
  igw_id              = module.vpc.igw_id
}

##-----------------------------------------------------------------------------
## Security Group Module Call.
##-----------------------------------------------------------------------------
module "security_group" {
  source      = "clouddrove/security-group/aws"
  version     = "2.0.2"
  name        = local.name
  environment = local.environment
  vpc_id      = module.vpc.vpc_id

  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "NFS from VPC"
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "Allow all outbound traffic."
    }
  ]
}

module "s3_bucket" {
  source = "./../../"

  name        = "s3filesytemexample"
  environment = local.environment
  label_order = local.label_order
  s3_name     = "s3filesytemexample"

  # S3 bucket encryption using an existing customer-managed KMS key.
  versioning                    = true
  force_destroy                 = true
  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_arn            = var.kms_key_arn

  # S3Files configuration.
  enable_s3files = true
  kms_key_arn    = var.kms_key_arn
  prefix         = "/"

  root_directory = {
    path = "/"

    creation_permissions = {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0755"
    }
  }

  posix_user = {
    gid            = 1000
    uid            = 1000
    secondary_gids = [1001, 1002]
  }

  subnet_id       = module.subnets.public_subnet_id
  security_groups = [module.security_group.security_group_id]

  import_data_rules = [{
    prefix         = "/"
    size_less_than = 524288000
    trigger        = "ON_FILE_ACCESS"
  }]

  expiration_data_rule = {
    days_after_last_access = 10
  }
}