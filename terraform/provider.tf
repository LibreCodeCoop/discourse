terraform {
  required_providers {
    digitalocean = {
      // https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs
      source  = "digitalocean/digitalocean"
      version = "~> 2.21.0"
    }
  }

  backend "s3" {
    endpoint                    = "https://sfo3.digitaloceanspaces.com"
    key                         = "infra/root.tfstate"
    region                      = "us-west-1"
    # bucket                      = "dbseller-ecidade-tf-state"
    bucket                      = "discourse-ecidade-tf-state"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

provider "digitalocean" {
  spaces_access_id  = var.SPACES_ACCESS_TOKEN
  spaces_secret_key = var.SPACES_SECRET_KEY
}
