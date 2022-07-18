resource "digitalocean_spaces_bucket" "discourse" {
  name   = "e-cidade-discourse-${terraform.workspace}-files"
  region = local.region
}