packer {
  required_plugins {
    digitalocean = {
      version = "~> 1.0.5"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

// variable "DOCKER_USER" {
//   type = string
// }

// variable "DOCKER_TOKEN" {
//   type = string
// }

// variable "DOCKER_REGISTRY" {
//   type = string
//   default = "ghcr.io"
// }