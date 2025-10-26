locals {
  common_scripts = [
    "${path.root}/scripts/common/sshd.sh",
  ]
  scripts = var.scripts == null ? (
    var.os_name == "ubuntu" ||
    var.os_name == "debian" ? [
      "${path.root}/scripts/${var.os_name}/systemd_${var.os_name}.sh",
      "${path.root}/scripts/${var.os_name}/cleanup_${var.os_name}.sh",
    ] : null
  ) : var.scripts
  nix_execute_command = "echo 'ansible' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"

  data_source_content = var.os_name == "ubuntu" ? {
    "/meta-data" = file("${abspath(path.root)}/http/ubuntu/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/http/ubuntu/user-data.pkrtpl.hcl", {
      ssh_pub_key = var.ssh_pub_key
    })
  } : null
}

build {
  sources = ["source.proxmox-iso.template"]

  # Install updates and reboot
  provisioner "shell" {
    execute_command   = local.nix_execute_command
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = ["${path.root}/scripts/common/update_packages.sh", ]
  }
  provisioner "shell" {
    inline = [
      "echo 'After reboot'"
    ]
    pause_after = "10s"
  }
  # Run common scripts
  provisioner "shell" {
    execute_command   = local.nix_execute_command
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = local.common_scripts
  }
  # Run OS specific scripts
  provisioner "shell" {
    execute_command   = local.nix_execute_command
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = local.scripts
  }
}