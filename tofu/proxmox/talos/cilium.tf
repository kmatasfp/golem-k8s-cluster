locals {
  cilium_values = file(var.cilium.values)
}

data "helm_template" "cilium" {
  namespace    = "kube-system"
  name         = "cilium"
  repository   = "https://helm.cilium.io"
  chart        = "cilium"
  version      = "1.17.0"
  kube_version = "1.32.1"
  values       = [local.cilium_values]
}
