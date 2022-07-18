#!/bin/sh

set -eu

docker-compose --version
docker --version

mkdir -p ~/.docker/cli-plugins/
URL=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".assets[] | select(.name | contains(\"linux-x86_64\")) | select(.name | contains(\"sha256\") | not) | .browser_download_url")

curl -SL $URL -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

docker compose version

curl -L https://raw.githubusercontent.com/docker/compose-switch/master/install_on_linux.sh | sh

docker --version
docker compose version
docker-compose --version