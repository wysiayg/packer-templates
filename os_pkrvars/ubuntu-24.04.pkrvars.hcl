os_name      = "ubuntu"
os_version   = "24.04"
os_arch      = "x86_64"
iso_url      = "https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.iso"
iso_checksum = "sha256:c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
# boot_command = ["<wait>e<wait><down><down><down><end> autoinstall ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu/<wait><f10><wait>"]
# boot_command = ["<wait>e<wait><down><down><down><end> autoinstall ds=nocloud;<wait><f10><wait>"]
boot_command  = ["c", "linux /casper/vmlinuz -- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", "<enter><wait><wait>", "initrd /casper/initrd", "<enter><wait><wait>", "boot<enter>"]
proxmox_vm_id = 1001