####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}


module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

####----------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
####----------------------------------------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.3.0"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

##----------------------------------------------------------------------------------
## Provides details about a default S3 bucket.
##----------------------------------------------------------------------------------
module "s3_bucket" {
  source = "./../../"

  name        = "clouddrove-secure-bucket"
  environment = "test"
  label_order = ["name", "environment"]
  acl         = "private"
  versioning = {
    status     = true
    mfa_delete = false
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.eu-west-1.s3"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = tolist(module.public_subnets.public_subnet_id)
  security_group_ids  = []
  route_table_ids     = []
  policy              = ""
  private_dns_enabled = false
  auto_accept         = false
}

#resource "aws_vpc_endpoint_subnet_association" "sn_ec2" {
#  vpc_endpoint_id = aws_vpc_endpoint.s3.id
#  subnet_id       = module.public_subnets.public_subnet_id[0]
#}

#resource "aws_vpc_endpoint_subnet_association" "subnet_association" {
#  count = var.enabled == true && var.enable_vpc_endpoint == true ? 1 : 0
#  vpc_endpoint_id = join("", aws_vpc_endpoint.endpoint.*.id)
#  subnet_id = element(aws_subnet.private.*.id, count.index)
#}