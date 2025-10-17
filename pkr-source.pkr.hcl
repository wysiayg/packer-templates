source "proxmox-iso" "template" {
    boot_command = "${var.boot_command}"
    boot_wait    = "10s"
    cores = 1
    cpu_type = host
    memory = 2048
    onboot = false

    disks {
        disk_size         = "5G"
        storage_pool      = "local-lvm"
        type              = "scsi"
        cache_mode = "writeback"
        format = "qcow2"
    }

    http_directory           = "http"
    insecure_skip_tls_verify = true

    boot_iso {
        type = "scsi"
        iso_file = "${var.iso_url}"
        unmount = true
        iso_checksum = "${var.iso_checksum}"
    }

    network_adapters {
        bridge = "vmbr0"
        model  = "virtio"
    }

    cloud_init = true
    cloud_init_storage_pool = "local"
    qemu_agent = true

    node                 = "${var.proxmox_node}"
    password             = "${var.password}"
    proxmox_url          = "${var.proxmox_url}"
    token = "${var.proxmox_token}"
    username             = "${var.proxmox_username}"

    ssh_password         = "packer"
    ssh_timeout          = "15m"
    ssh_username         = "${var.template_ssh_pass}"

    template_description = "${var.os_name} ${var.os_version}, generated on ${timestamp()}"
    template_name        = "${var.os_name}-${var.os_version}-template"
    tags = "template"
}