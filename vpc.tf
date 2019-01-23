# resource "aws_eip" "nat" {
#   count = 3

#   vpc = true
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.product}-${var.environment}"
  cidr = "10.0.0.0/16"

  azs              = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  reuse_nat_ips = true # Skip creation of EIPs for the NAT Gateways

  # external_nat_ip_ids = ["${aws_eip.nat.*.id}"] # IPs specified here as input to the module

  enable_dns_hostnames = true # disable this later
  enable_dns_support   = true # disable this later
  tags = {
    Terraform   = "true"
    Name        = "${var.product}-${var.environment}"
    Environment = "${var.environment}"
    Product     = "${var.product}"
  }
  public_subnet_tags = {
    Terraform   = "true"
    Name        = "${var.product}-${var.environment}-public"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Public"
  }
  private_subnet_tags = {
    Terraform   = "true"
    Name        = "${var.product}-${var.environment}-private"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Private"
  }
  database_subnet_tags = {
    Terraform   = "true"
    Name        = "${var.product}-${var.environment}-database"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Database"
  }
}

data "aws_vpc" "main" {
  id = "${module.vpc.vpc_id}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.main.id}"
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.main.id}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.main.id}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Private"
  }
}

data "aws_subnet_ids" "database" {
  vpc_id = "${data.aws_vpc.main.id}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Product     = "${var.product}"
    Tier        = "Database"
  }
}
