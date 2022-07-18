resource "digitalocean_database_cluster" "database" {
  name       = "postgres-${local.environment}-cluster"
  engine     = "pg"
  version    = "14"
  size       = "db-s-1vcpu-1gb"
  node_count = 1
  region     = local.region
  tags       = concat(local.tags_discourse, [digitalocean_tag.databases.id])

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      node_count,
      size
    ]
  }
}

resource "digitalocean_database_db" "discourse" {
  cluster_id  = digitalocean_database_cluster.database.id
  name        = "discourse_${local.environment}"

  lifecycle {
    prevent_destroy = true
  }
}
