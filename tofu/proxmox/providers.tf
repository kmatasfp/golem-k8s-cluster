# tofu/providers.tf
terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }

  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  api_token = var.proxmox.api_token
  ssh {
    agent       = false
    username    = var.proxmox.username
    private_key = file(var.proxmox.ssh_private_key)
  }
}

provider "kubernetes" {
  host                   = module.talos.kube_config.kubernetes_client_configuration.host
  client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
}
