resource "aws_route53_record" "blogBiqueirabr" {
  name = "blog.biqueirabr.com.br"
  type = "A"
  zone_id = var.hostedDnsZoneID
  ttl = "300"

  records = [var.ec2PublicIP]
}
