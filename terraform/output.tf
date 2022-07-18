output "discourse-droplets" {
  value = flatten([for v in digitalocean_droplet.discourse : v.ipv4_address])
}

output "database" {
  value = {
    port         = digitalocean_database_cluster.database.port
    host         = digitalocean_database_cluster.database.host
    private_host = digitalocean_database_cluster.database.private_host
    databases = [
      digitalocean_database_db.discourse.name
    ]
  }
}

output "storage" {
  value = {
    bucket             = digitalocean_spaces_bucket.discourse.name
    bucket_domain_name = digitalocean_spaces_bucket.discourse.bucket_domain_name
  }
}
