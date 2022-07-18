locals {
  tags_discourse = [
    digitalocean_tag.environment.id,
    digitalocean_tag.discourse.id
  ]
}

resource "digitalocean_tag" "environment" {
  name = local.environment
}

resource "digitalocean_tag" "discourse" {
  name = "app-discourse"
}

resource "digitalocean_tag" "droplets" {
  name = "droplet-${local.environment}"
}

resource "digitalocean_tag" "databases" {
  name = "database-${local.environment}"
}