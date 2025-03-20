locals {
  cilium_values = file(var.cilium.values)

  cilium_l2_announcement_policy = yamlencode(
    {
      apiVersion = "cilium.io/v2alpha1"
      kind       = "CiliumL2AnnouncementPolicy"
      metadata = {
        name = "external"
      }
      spec = {
        loadBalancerIPs = true
        externalIPs     = true
      }
    }
  )

  cilium_lb_ip_pool = yamlencode({
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumLoadBalancerIPPool"
    metadata = {
      name = "external"
    }
    spec = {
      blocks = [
        {
          start = var.cilium.lb_ip_pool_start
          stop  = var.cilium.lb_ip_pool_end
        },
      ]
    }
  })

}

data "helm_template" "cilium" {
  namespace    = "kube-system"
  name         = "cilium"
  repository   = "https://helm.cilium.io"
  chart        = "cilium"
  version      = "1.17.2"
  kube_version = "1.32.0"
  api_versions = [
    "gateway.networking.k8s.io/v1/GatewayClass",
    "gateway.networking.k8s.io/v1/Gateway",
    "gateway.networking.k8s.io/v1/HTTPRoute",
    "gateway.networking.k8s.io/v1/TLSRoute",
    "gateway.networking.k8s.io/v1/ReferenceGrant",
    "gateway.networking.k8s.io/v1/GRPCRoute"
  ]
  values = [local.cilium_values]
}
