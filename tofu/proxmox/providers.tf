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
    flux = {
      source  = "fluxcd/flux"
      version = "1.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
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

provider "flux" {
  kubernetes = {
    host = module.talos.kube_config.kubernetes_client_configuration.host

    client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
  }

  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = var.github_token
    }
  }
}

provider "helm" {
  # kubernetes {
  #   host = module.talos.kube_config.kubernetes_client_configuration.host

  #   client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
  #   client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
  #   cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
  # }
}
