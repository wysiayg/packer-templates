source "proxmox-iso" "template" {
  boot_command = "${var.boot_command}"
  boot_wait    = "10s"
  boot         = "order=scsi0;ide0"
  cores        = 2
  cpu_type     = "host"
  memory       = 4096
  onboot       = false
  vm_id        = "${var.proxmox_vm_id}"

  disks {
    disk_size    = "5G"
    storage_pool = "${var.proxmox_disk_storage_pool}"
    type         = "scsi"
    cache_mode   = "writeback"
    format       = "raw"
  }

  http_content   = "${local.data_source_content}" != null ? "${local.data_source_content}" : null
  http_directory = "${local.data_source_content}" != null ? null : "http"
  http_port_min  = "${var.packer_http_port_min}"
  http_port_max  = "${var.packer_http_port_max}"

  # additional_iso_files {
  #   cd_files = ["${path.root}/install_data/${var.os_name}/*"]
  #   cd_label = "cidata"
  #   iso_storage_pool = "${var.proxmox_iso_storage_pool}"
  #   unmount = true
  # }

  insecure_skip_tls_verify = true
  boot_iso {
    type             = "ide"
    iso_url          = "${var.iso_url}"
    unmount          = true
    iso_checksum     = "${var.iso_checksum}"
    iso_storage_pool = "${var.proxmox_iso_storage_pool}"
    iso_download_pve = true
  }

  network_adapters {
    bridge   = "${var.proxmox_network_bridge}"
    model    = "${var.proxmox_network_model}"
    vlan_tag = "${var.proxmox_network_vlan_tag}"
  }

  qemu_agent = true

  node        = "${var.proxmox_node}"
  proxmox_url = "${var.proxmox_url}"
  token       = "${var.proxmox_token}"
  username    = "${var.proxmox_username}"

  ssh_timeout    = "15m"
  ssh_username   = "ansible"
  ssh_agent_auth = true

  template_description = "${var.os_name} ${var.os_version}, generated on ${timestamp()}"
  template_name        = "${var.os_name}-${var.os_version}-template"
  tags                 = "template"
}