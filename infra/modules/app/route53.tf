resource "aws_route53_record" "www" {
  count = var.enable_dns ? 1 : 0

  zone_id = var.host_zone_id
  name    = "${var.app}.example.com" # ziwon-rest-api-dev.example.com
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
