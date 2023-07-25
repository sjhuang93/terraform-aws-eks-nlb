variable "base" {
  type = object({
    platform = string
    cluster_id = string
    node_subnet_ids = list(string)
    public_subnet_ids = list(string)
  })
}

variable "service" {
  type = object({
    name = string
    namespace = string
    target_port = string
    security_group_id = string
    pod_selector = map(string)
  })
}

variable "nlb_class" {
  type    = string
  default = null
}

variable "federations" {
  type = map(object({
    domain = string
    hosts = map(string)
    create_dns_record = bool
  }))
}

variable "expose_target_ports" {
  type = map
  default = {}
}

variable "health_check" {
  type = map
  default = {}
}

variable "attributes" {
  type = map
  default = {
    preserve_client_ip = false
    proxy_protocol_v2  = false
  }
}