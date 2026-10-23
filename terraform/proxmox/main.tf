resource "proxmox_virtual_environment_vm" "homelab-master" {
  name      = "homelab-master"
  node_name = "pve"

  clone {
    vm_id = 9000
  }

  memory {
    dedicated = 4096
  }
  
  cpu {
    cores = 2
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 32
  }

  initialization {
    dns {
      servers = ["1.1.1.1"]
    }
    ip_config {
      ipv4 {
        address = "192.168.0.201/24"
        gateway = "192.168.0.1"
      }
    }

    user_account {
      keys     = [trimspace(file(pathexpand("~/.ssh/homelab.pub")))]
      username = "homelab"
    }

  }
}

