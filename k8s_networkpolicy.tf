resource "kubernetes_network_policy_v1" "traffic_to_pod" {
  for_each = length(var.expose_target_ports) > 0 ? var.expose_target_ports : {}

  metadata {
    name      = data.aws_lb.nlb.internal ? "ingress-policy-cidr2pod-from-internal-to-${var.service.namespace}-${var.service.name}-${each.value.container_port}" : "ingress-policy-cidr2pod-from-internet-to-${var.service.namespace}-${var.service.name}-${each.value.container_port}"
    namespace = var.service.namespace
    labels    = {
      "managed-by" = "terraform"
    }

  }

  spec {
    pod_selector {
      match_labels = length(var.service.pod_selector) > 0 ? var.service.pod_selector : {
        app = var.service.name
      }
    }

    ingress {
      ports {
        port     = each.value.container_port
        protocol = each.value.protocol
      }

      from {
        ip_block {
          cidr = data.aws_lb.nlb.internal ? "10.0.0.0/8" : "0.0.0.0/0"
        }  
      } 
    }

    policy_types = ["Ingress"]
  }
}