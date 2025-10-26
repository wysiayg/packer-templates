# builder common block
variable "scripts" {
  type    = list(string)
  default = null
}

########################################################################
# Environment specific variables. Be careful not to share those.
########################################################################
variable "proxmox_node" {
  description = "Which node in the Proxmox cluster to start the virtual machine on during creation."
  type        = string
}
variable "proxmox_url" {
  description = "URL to the Proxmox API, including the full path, so https://<server>:<port>/api2/json for example."
  type        = string
}
variable "proxmox_token" {
  description = "Token for authenticating API calls."
  type        = string
  sensitive   = true
}
variable "proxmox_username" {
  description = "Username when authenticating to Proxmox, including the realm. For example user@pve to use the local Proxmox realm. When using token authentication, the username must include the token id after an exclamation mark. For example, user@pve!tokenid."
  type        = string
  sensitive   = true
}
variable "proxmox_iso_storage_pool" {
  type        = string
  description = "Proxmox storage pool onto which to upload the ISO file."
}
variable "ssh_pub_key" {
  type        = string
  description = "Authorized key for the CM user."
  sensitive   = true
}
variable "proxmox_vm_id" {
  type        = number
  description = "The ID used to reference the virtual machine. This will also be the ID of the final template."
}

variable "proxmox_cloudinit_storage_pool" {
  type        = string
  description = "Name of the Proxmox storage pool to store the Cloud-Init CDROM on."
}

variable "proxmox_disk_storage_pool" {
  type        = string
  description = "Name of the Proxmox storage pool to store the virtual machine disk on."
}

variable "proxmox_network_bridge" {
  description = "Which Proxmox bridge to attach the adapter to."
  type        = string
  default     = "vmbr0"
}

variable "proxmox_network_model" {
  description = "Model of the virtual network adapter."
  type        = string
  default     = "virtio"
}

variable "proxmox_network_vlan_tag" {
  description = "If the adapter should tag packets. Defaults to no tagging."
  type        = string
  default     = null
}

variable "packer_http_port_min" {
  description = "These are the minimum and maximum port to use for the HTTP server started to serve the http_directory"
  type        = number
  default     = 8000
}

variable "packer_http_port_max" {
  description = "These are the minimum and maximum port to use for the HTTP server started to serve the http_directory"
  type        = number
  default     = 9000
}

########################################################################
# OS specific variables. Should be set by the os_pkrvars files.
########################################################################
variable "os_name" {
  type        = string
  description = "Name of OS. Used to derive script paths."
}
variable "os_version" {
  type        = string
  description = "Version of OS"
}
variable "os_arch" {
  type        = string
  description = "Arch of OS"
}
variable "iso_url" {
  type        = string
  description = "A URL to the ISO containing the installation image."
}
variable "iso_checksum" {
  type        = string
  description = "The checksum for the ISO file. The type of the checksum is specified within the checksum field as a prefix, e. g. 'file:{$path}' or 'sha256:{$checksum}'"
}
variable "boot_command" {
  type        = list(string)
  description = "This is an array of commands to type when the virtual machine is first booted."
}