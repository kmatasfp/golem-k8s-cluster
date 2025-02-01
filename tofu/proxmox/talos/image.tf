# tofu/talos/image.tf
data "talos_image_factory_extensions_versions" "this" {
  # get the latest talos version
  talos_version = var.image.version
  filters = {
    names = var.image.system_extensions
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

resource "proxmox_virtual_environment_download_file" "this" {
  for_each = toset(distinct([for k, v in var.nodes : "${v.host_node}"]))

  node_name    = each.value
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  file_name               = "talos-${talos_image_factory_schematic.this.id}-${var.image.version}-${var.image.platform}-${var.image.arch}.img"
  url                     = "${var.image.factory_url}/image/${talos_image_factory_schematic.this.id}/${var.image.version}/${var.image.platform}-${var.image.arch}.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
