locals {
  proxmox_csi_helm_values = yamlencode(
    {
      createNamespace = true
      storageClass = [{
        name    = "proxmox-data-xfs"
        storage = var.proxmox.storage
        annotations = {
          "storageclass.kubernetes.io/is-default-class" = "true"
        }
        reclaimPolicy = "Delete"
        fstype        = "xfs"
        cache         = "writethrough"
        ssd           = true
        mountOptions  = ["noatime"]
        }
      ]
      config = {
        clusters = [
          {
            url          = "${var.proxmox.csi_api_endpoint}/api2/json"
            insecure     = var.proxmox.insecure
            token_id     = var.kubernetes_csi_token.id
            token_secret = "${element(split("=", var.kubernetes_csi_token.value), length(split("=", var.kubernetes_csi_token.value)) - 1)}"
            region       = var.proxmox.cluster_name
          }
        ]
      }
    }
  )
}


data "helm_template" "proxmox-csi" {
  namespace    = "csi-proxmox"
  name         = "proxmox-csi-plugin"
  repository   = "oci://ghcr.io/sergelogvinov/charts"
  chart        = "proxmox-csi-plugin"
  version      = "0.3.5"
  kube_version = "1.32.0"

  values = [local.proxmox_csi_helm_values]
}
