variable "proxmox" {
  type = object({
    name            = string
    cluster_name    = string
    endpoint        = string
    insecure        = bool
    username        = string
    api_token       = string
    ssh_private_key = string
  })
  sensitive = true
}
