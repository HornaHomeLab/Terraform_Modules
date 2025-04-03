data "local_sensitive_file" "ssh_pubkey" {
  count    = var.ssh_pubkey_file != null ? 1 : 0
  filename = var.ssh_pubkey_file
}
data "local_sensitive_file" "default_password" {
  count    = var.default_password_file != null ? 1 : 0
  filename = var.default_password_file
}

locals {
  # Use [0] if the data source exists, otherwise fall back to null
  ssh_pubkey_content = var.ssh_pubkey != null ? var.ssh_pubkey : (
    length(data.local_sensitive_file.ssh_pubkey) > 0 ? data.local_sensitive_file.ssh_pubkey[0].content : null
  )

  default_password_content = var.default_password != null ? var.default_password : (
    length(data.local_sensitive_file.default_password) > 0 ? data.local_sensitive_file.default_password[0].content : null
  )
}


resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  desc        = var.vm_desc
  vmid        = var.vmid != null ? var.vmid : null
  tags        = join(",", concat(var.tags != null ? var.tags : [], ["terraform", "ubuntu-24-04"]))
  target_node = var.target_node

  tablet = false

  onboot     = true
  clone      = "ubuntu-cloud-init-template"
  full_clone = true

  agent = 1

  os_type = "cloud-init"
  cores   = var.cores
  sockets = 1
  memory  = var.memory
  boot    = "order=scsi0"

  scsihw = "virtio-scsi-single"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = var.disk_size
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ciupgrade  = false
  ciuser     = "proxmox"
  cipassword = local.default_password_content
  skip_ipv6  = true
  nameserver = join(",", var.dns_servers)
  ipconfig0  = "ip=${var.ip_address}/${var.cidr_netmask},gw=${var.gateway}"

  sshkeys = local.ssh_pubkey_content
}

output "deployed_vms" {
  value = proxmox_vm_qemu.vm
}
