data "aws_lb" "nlb" {
  tags = {
    "elbv2.k8s.aws/cluster"    = var.base.cluster_id
    "service.k8s.aws/resource" = "LoadBalancer"
    "service.k8s.aws/stack"    = var.nlb_class
  }
}

data "aws_lb_hosted_zone_id" "nlb" {
  load_balancer_type = "network"
}

data "aws_eks_cluster" "selected" {
  name = var.base.cluster_id
}