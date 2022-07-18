locals {
  trusted_ssh_fingerprints = [
    "11:54:a0:30:1c:8b:4d:35:6c:6e:2e:c5:fe:93:03:9b", // Vinicius Reis
    # "37:8d:c4:83:30:12:30:1e:63:14:c5:a8:15:e3:90:a0", // Vitor Mattos
  ]
}

locals {
  region      = "sfo3"
  cname       = var.TARGET_DOMAIN
  environment = terraform.workspace
}

variable "SPACES_SECRET_KEY" {
  type = string
  description = "Spaces Secret Key"
}

variable "SPACES_ACCESS_TOKEN" {
  type = string
  description = "Spaces Access Token"
}

variable "TARGET_DOMAIN" {
  type = string
  default = "ecidade.softwarepublico.org"
  description = "Target domain/cname"
}