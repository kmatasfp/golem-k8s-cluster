variable "proxmox" {
  type = object({
    name            = string
    cluster_name    = string
    endpoint        = string
    insecure        = bool
    username        = string
    api_token       = string
    ssh_private_key = string
    storage         = string
  })
  sensitive = true
}

variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
}
