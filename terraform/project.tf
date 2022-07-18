resource "digitalocean_project" "discourse" {
  name        = "Discourse [${local.environment}]"
  description = "e-Cidade Discourse cluster (${local.environment})"
  purpose     = "Web Application"
  environment = title(local.environment)
}


// add droplets to project
resource "digitalocean_project_resources" "droplets" {
  project   = digitalocean_project.discourse.id
  resources = [for v in digitalocean_droplet.discourse : v.urn]
}
