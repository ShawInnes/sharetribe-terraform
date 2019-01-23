module "app_ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  instance_count         = 1
  name                   = "${var.environment}-${var.product}-app"
  key_name               = "${var.key_name}"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${element(data.aws_subnet_ids.private.ids, 0)}"
  vpc_security_group_ids = ["${module.app_sg.this_security_group_id}"]
}
