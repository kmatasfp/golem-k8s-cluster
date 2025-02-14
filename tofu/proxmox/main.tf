module "proxmox_csi_plugin" {

  source = "./bootstrap/proxmox-csi-plugin"

  providers = {
    proxmox = proxmox
  }

  proxmox = var.proxmox
}


module "talos" {
  depends_on = [module.proxmox_csi_plugin]

  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  image = {
    version           = "v1.9.3"
    proxmox_datastore = "ISOs"
    system_extensions = ["amd-ucode", "qemu-guest-agent"]
  }

  cilium = {
    values           = "${path.module}/talos/inline-manifests/cilium/values.yaml"
    lb_ip_pool_start = "10.10.40.220"
    lb_ip_pool_end   = "10.10.40.255"
  }

  proxmox = var.proxmox

  kubernetes_csi_token = module.proxmox_csi_plugin.kubernetes_csi_token

  cluster = {
    name               = "golem-k8s-cluster"
    endpoint           = "10.10.40.30"
    bootstrap_endpoint = "10.10.40.31"
    gateway            = "10.10.40.1"
    talos_version      = "v1.9.3"
    proxmox_cluster    = "homelab"
  }

  nodes = {
    "ctrl-00" = {
      host_node     = "pve-2"
      machine_type  = "controlplane"
      ip            = "10.10.40.31"
      mac_address   = "BC:24:11:2E:C8:00"
      vm_id         = 300
      cpu           = 8
      ram_dedicated = 8192
      datastore_id  = var.proxmox.storage
      disk_size     = 256
      bridge        = "vmbr1"
      vlan_id       = 40
    }
    "ctrl-01" = {
      host_node     = "pve-2"
      machine_type  = "controlplane"
      ip            = "10.10.40.32"
      mac_address   = "BC:24:11:2E:C8:01"
      vm_id         = 301
      cpu           = 8
      ram_dedicated = 8192
      datastore_id  = var.proxmox.storage
      disk_size     = 256
      bridge        = "vmbr1"
      vlan_id       = 40
    }
    "ctrl-02" = {
      host_node     = "pve-2"
      machine_type  = "controlplane"
      ip            = "10.10.40.33"
      mac_address   = "BC:24:11:2E:C8:02"
      vm_id         = 302
      cpu           = 8
      ram_dedicated = 4096
      datastore_id  = var.proxmox.storage
      disk_size     = 256
      bridge        = "vmbr1"
      vlan_id       = 40
    }
    "work-00" = {
      host_node     = "pve-2"
      machine_type  = "worker"
      ip            = "10.10.40.40"
      mac_address   = "BC:24:11:2E:08:00"
      vm_id         = 310
      cpu           = 8
      ram_dedicated = 8192
      datastore_id  = var.proxmox.storage
      disk_size     = 256
      bridge        = "vmbr1"
      vlan_id       = 40
    }
  }
}



module "fluxcd" {
  depends_on = [module.talos]
  source     = "./bootstrap/flux"

  providers = {
    flux = flux
  }

  github_org        = var.github_org
  github_repository = var.github_repository
  github_token      = var.github_token
}
