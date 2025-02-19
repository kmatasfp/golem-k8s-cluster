variable "image" {
  description = "Talos image configuration"
  type = object({
    factory_url       = optional(string, "https://factory.talos.dev")
    version           = string
    arch              = optional(string, "amd64")
    platform          = optional(string, "nocloud")
    proxmox_datastore = optional(string, "local")
    system_extensions = optional(list(string), [])
  })
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name               = string
    endpoint           = string
    bootstrap_endpoint = string
    gateway            = string
    talos_version      = string
    proxmox_cluster    = string
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node     = string
    machine_type  = string
    datastore_id  = optional(string, "local-zfs")
    ip            = string
    mac_address   = string
    vm_id         = number
    cpu           = number
    ram_dedicated = number
    disk_size     = number
    bridge        = optional(string, "vmbr0")
    vlan_id       = optional(number)
  }))
}

variable "cilium" {
  description = "Cilium configuration"
  type = object({
    values           = string
    lb_ip_pool_start = string
    lb_ip_pool_end   = string
  })
}

variable "kubernetes_csi_token" {
  type = object(
    {
      id    = string
      value = string
    }
  )
}

variable "proxmox" {
  type = object({
    cluster_name     = string
    csi_api_endpoint = string
    insecure         = bool
    storage          = string
  })
}
