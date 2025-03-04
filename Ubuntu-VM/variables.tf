variable "vm_name" {
  description = "The name of the VM"
  type        = string
}
variable "vm_desc" {
  description = "The description of the VM"
  type        = string

}
variable "vmid" {
  description = "The VMID of the VM"
  type        = number
  default     = null
}
variable "tags" {
  description = "The tags of the VM"
  type = list(string)
  default = null
}
variable "target_node" {
  description = "The target node to deploy the VM"
  type        = string
  default     = "pve-r7"
}
variable "cores" {
  description = "The number of cores"
  type        = number
  default     = 4
}
variable "memory" {
  description = "The amount of memory"
  type        = number
  default     = 4096
}
variable "disk_size" {
  description = "The size of the disk"
  type        = string
  default     = "64G"
}
variable "ssh_pubkey_file" {
  description = "The path to the ssh public key file"
  type        = string
  default     = "../secrets/key/id_rsa.pub"
}
variable "default_password_file" {
  description = "The path to the default password file"
  type        = string
  default     = "../secrets/PRX_pass"
}
variable "ip_address" {
  description = "The ip address of the VM"
  type        = string
}
variable "cidr_netmask" {
  description = "The netmask of the VM in format like 24"
  type        = number
}
variable "gateway" {
  description = "The gateway of the VM"
  type        = string
}
variable "dns_servers" {
  description = "The dns servers of the VM"
  type        = list(string)
  default     = ["1.1.1.1"]
}
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}