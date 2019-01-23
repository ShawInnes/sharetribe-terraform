resource "aws_eip" "this" {
  vpc      = true
  instance = "${module.bastion_ec2.id[0]}"
}

module "bastion_ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  instance_count              = 1
  name                        = "${var.environment}-${var.product}-bastion"
  key_name                    = "${var.key_name}"
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, 0)}"
  vpc_security_group_ids      = ["${module.bastion_sg.this_security_group_id}"]
  associate_public_ip_address = true
}
