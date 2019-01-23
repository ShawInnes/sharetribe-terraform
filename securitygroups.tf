module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.product}-${var.environment}-bastion"
  vpc_id = "${data.aws_vpc.main.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = {
    Name        = "${var.product}-${var.environment}-bastion"
    Environment = "${var.environment}"
    Product     = "${var.product}"
  }
}

module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.product}-${var.environment}-app"
  vpc_id = "${data.aws_vpc.main.id}"

  number_of_computed_ingress_with_source_security_group_id = 1

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = "${module.bastion_sg.this_security_group_id}"
    },
  ]

  egress_rules = ["all-all"]

  tags = {
    Name        = "${var.product}-${var.environment}-app"
    Environment = "${var.environment}"
    Product     = "${var.product}"
  }
}
