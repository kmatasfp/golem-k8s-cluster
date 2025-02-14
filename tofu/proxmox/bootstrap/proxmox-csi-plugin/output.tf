output "kubernetes_csi_token" {
  value     = proxmox_virtual_environment_user_token.kubernetes-csi-token
  sensitive = true
}
