resource "kubernetes_manifest" "target_group_binding" {
  for_each = var.expose_target_ports

  manifest = {
    "apiVersion" = "elbv2.k8s.aws/v1beta1"
    "kind"       = "TargetGroupBinding"
    "metadata" = {
      "name"      = "${var.service.name}-${each.value.container_port}" 
      "namespace" = "${var.service.namespace}"
      labels      = {
        "service.k8s.aws/stack-name"      = "${var.service.name}"
        "service.k8s.aws/stack-namespace" = "${var.service.namespace}"
      }
    }
    "spec" = {
      "ipAddressType"  = "ipv4"
      "targetType"     = "ip"
      "targetGroupARN" = "${aws_lb_target_group.this[each.key].arn}"
      "serviceRef"     = {
        "name" = "${var.service.name}"
        "port" = "${each.value.container_port}"
      }
    }
  }
}