output "client_configuration" {
  value     = data.talos_client_configuration.this
  sensitive = true
}

output "kube_config" {
  value     = resource.talos_cluster_kubeconfig.this
  sensitive = true
}

output "machine_config" {
  value = data.talos_machine_configuration.this
}

output "schematic_id" {
  value = talos_image_factory_schematic.this.id
}
