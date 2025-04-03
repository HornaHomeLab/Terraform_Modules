data "local_sensitive_file" "ssh_pubkey" {
  filename = var.ssh_pubkey_file
}
data "local_sensitive_file" "default_password" {
  filename = var.default_password_file
}


resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  desc        = var.vm_desc
  vmid        = var.vmid != null ? var.vmid : null
  tags        = join(",",concat(var.tags != null ? var.tags : [], ["terraform","ubuntu-24-04"]))
  target_node = var.target_node
  
  tablet = false
  
  onboot = true
  clone = "ubuntu-cloud-init-template"
  full_clone = true

  agent  = 1

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
  cipassword = var.default_password != null ? var.default_password : data.local_sensitive_file.default_password.content
  skip_ipv6  = true
  nameserver = join(",", var.dns_servers)
  ipconfig0  = "ip=${var.ip_address}/${var.cidr_netmask},gw=${var.gateway}"

  sshkeys = var.ssh_pubkey != null ? var.ssh_pubkey : data.local_sensitive_file.ssh_pubkey.content
}

output "deployed_vms" {
  value = proxmox_vm_qemu.vm
}
