####----------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####----------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-2"
}


module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "mamraj"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

####----------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
####----------------------------------------------------------------------------------
module "subnets" {
  source              = "clouddrove/subnet/aws"
  version             = "2.0.0"
  nat_gateway_enabled = true
  single_nat_gateway  = true
  name                = "subnet"
  environment         = "mamraj"
  availability_zones  = ["eu-west-2a", "eu-west-2b"]
  vpc_id              = module.vpc.vpc_id
  type                = "public-private"
  igw_id              = module.vpc.igw_id
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  enable_ipv6         = false
}

##-----------------------------------------------------
## An AWS security group acts as a virtual firewall for incoming and outgoing traffic with http-https.
##-----------------------------------------------------
module "http_https" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = "http-https"
  environment = "mamraj"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

##-----------------------------------------------------
## An AWS security group acts as a virtual firewall for incoming and outgoing traffic with ssh.
##-----------------------------------------------------
module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name          = "ssh"
  environment   = "mamraj"
  label_order   = ["name", "environment"]
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22]
}

module "vpc_endpoint" {
  source              = "./../../"
  name                = "endpoint"
  environment         = "mamraj"
  label_order         = ["name", "environment"]
  enable_vpc_endpoint = true

  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.eu-west-2.s3"
  subnet_id          = module.subnets.private_subnet_id[0]
  security_group_ids = [module.ssh.security_group_ids, module.http_https.security_group_ids]
  #  route_table_ids   = [module.subnets.public_route_tables_id[0]]
  private_dns_enabled = false
}
