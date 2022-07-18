
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "digitalocean" "ubuntu" {
  droplet_name            = "packer-librecode-base-${local.timestamp}"
  image                   = "ubuntu-20-04-x64"
  private_networking      = true
  region                  = "sfo3"
  size                    = "s-1vcpu-1gb"
  snapshot_name           = "librecode-base-${local.timestamp}"
  ssh_username            = "root"
  pause_before_connecting = "30s"
  tags                    = ["packer"]
}