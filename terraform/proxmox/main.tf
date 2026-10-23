locals {
  vms = {
    "homelab-master"  = "192.168.0.201"
    "homelab-worker1" = "192.168.0.202"
    "homelab-worker2" = "192.168.0.203"

  }
}

resource "proxmox_virtual_environment_vm" "k8s" {

  for_each  = local.vms
  name      = each.key
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

  agent {
    enabled = true
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
        address = "${each.value}/24"
        gateway = "192.168.0.1"
      }
    }

    user_account {
      keys     = [trimspace(file(pathexpand("~/.ssh/homelab.pub")))]
      username = "homelab"
    }

  }
}

