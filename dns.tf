data "aws_route53_zone" "base_zone" {
  name = "${var.zone}"
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = "${var.zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "base_zone_acm_validation" {
  zone_id = "${data.aws_route53_zone.base_zone.zone_id}"
  name    = "${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_type}"
  ttl     = "300"
  records = ["${aws_acm_certificate.certificate.domain_validation_options.0.resource_record_value}"]
}
