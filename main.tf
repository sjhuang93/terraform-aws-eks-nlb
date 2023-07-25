resource "aws_lb_listener" "this" {
  for_each = var.expose_target_ports

  load_balancer_arn = data.aws_lb.nlb.arn
  port              = each.value.expose_port
  protocol          = each.value.protocol
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}

resource "aws_lb_target_group" "this" {
  for_each    = var.expose_target_ports

  name        = "${var.service.name}-${each.value.container_port}"
  port        = each.value.container_port
  protocol    = each.value.protocol
  vpc_id      = data.aws_eks_cluster.selected.vpc_config[0].vpc_id
  target_type = "ip"

  ## attributes
  preserve_client_ip = var.attributes.preserve_client_ip
  proxy_protocol_v2  = var.attributes.proxy_protocol_v2

  ## tags
  tags = {
    "elbv2.k8s.aws/cluster"    = "${data.aws_eks_cluster.selected.id}"
    "service.k8s.aws/resource" = "${var.service.namespace}-${var.service.name}-${each.value.container_port}"
    "service.k8s.aws/stack"    = "${var.service.namespace}-${var.service.name}"
  }
}
