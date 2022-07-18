#!/bin/bash


_colorClear='\033[0m'
_colorError='\033[1;31m'

echoWarning() {
    echo -e "${_colorError}$1${_colorClear}"
}

# check variables
for var in SPACES_ACCESS_TOKEN SPACES_SECRET_KEY DIGITALOCEAN_ACCESS_TOKEN TARGET_DOMAIN; do
    if [ -z "${!var}" ] ; then
      echoWarning "$var is not set"
    fi
done

# Translate spaces credentials to s3 credentials
export AWS_ACCESS_KEY=$SPACES_ACCESS_TOKEN
export AWS_SECRET_KEY=$SPACES_SECRET_KEY

# Inject terraform variables
export TF_VAR_SPACES_ACCESS_TOKEN=$SPACES_ACCESS_TOKEN
export TF_VAR_SPACES_SECRET_KEY=$SPACES_SECRET_KEY
export TF_VAR_TARGET_DOMAIN=$TARGET_DOMAIN
# export TF_VAR_CLOUDFLARE_API_TOKEN=$CLOUDFLARE_API_TOKEN

# Inject Packer variables
# export PKR_VAR_DOCKER_USER=$GH_DOCKER_USER
# export PKR_VAR_DOCKER_TOKEN=$GH_DOCKER_TOKEN
{
  eval "$(ssh-agent -s)"
  ssh-add /root/.ssh/id_rsa
} &> /dev/null

[[ ! -z "$SSH_HOST_KEY" ]] && ssh-add /root/.ssh/$SSH_HOST_KEY || echoWarning "$SSH_HOST_KEY is not set"

echo "🧱 LibreCode Infra tooling"

exec "$@"