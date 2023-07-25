data "aws_route53_zone" "domain" {
  for_each = {
    for federation, value in var.federations:
      federation => value if lookup(value.hosts, var.service.name, "") != ""
  }

  name         = each.value.domain
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = {
    for federation, value in var.federations:
      federation => value if lookup(value.hosts, var.service.name, "") != ""
  }

  zone_id = data.aws_route53_zone.domain[each.key].zone_id
  name    = each.value.hosts[var.service.name]
  type    = "A"

  alias {
    name                   = data.aws_lb.nlb.dns_name
    zone_id                = data.aws_lb_hosted_zone_id.nlb.id
    evaluate_target_health = true
  }
}