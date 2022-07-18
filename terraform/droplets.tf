data "digitalocean_droplet_snapshot" "base" {
  name_regex  = "^librecode-base-"
  region      = local.region
  most_recent = true
}

resource "digitalocean_droplet" "discourse" {
  count      = 1
  image      = data.digitalocean_droplet_snapshot.base.id
  name       = "discourse-${local.environment}-${count.index}"
  size       = "s-1vcpu-1gb"
  region     = local.region
  ssh_keys   = local.trusted_ssh_fingerprints
  tags       = concat(local.tags_discourse, [digitalocean_tag.droplets.id])
  monitoring = true
  user_data = templatefile(
    "${path.module}/templates/ignition.yml.template",
    {
      CNAME       = "droplet-${count.index}.${local.cname}",
      ENVIRONMENT = local.environment
    }
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      image,
      ssh_keys
    ]
  }
}
