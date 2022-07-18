#!/bin/sh
set -e

OPTIND=1

ENV=$1

banner() {
  cat /etc/ssh/banner &&
    echo "🚀 LibreCode Setup Script"
}

setupSSH() {
  echo '@> 🔑 Setup SSH Agent' &&
    eval "$(ssh-agent)" &&
    ssh-add || true &&
    echo '@> end'
}

setupSwap() {
  echo '@> 🧠 Swap setup' &&
    sudo fallocate -l 2G /swapfile &&
    sudo chmod 600 /swapfile &&
    sudo mkswap /swapfile &&
    sudo swapon /swapfile &&
    sudo swapon --show &&
    sudo sysctl vm.swappiness=40 &&
    echo 'vm.swappiness=40' | sudo tee -a /etc/sysctl.conf &&
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab &&
    echo '@> end'
}

setupDOAgent() {
  echo "📡 Intall DO Agent"
  curl -sSL https://repos-droplet.digitalocean.com/install.sh | sudo bash
  echo '@> end'
}

setupOps() {
  echo '@> 💻 OPS Setup' &&
    echo "@>> Nothing to do yet" &&
    echo '@> end'
}

hostInfo() {
  echo "@> 👻 Host: $(hostname)" &&
    sed -i "s/__HOSTNAME__/$(hostname)/g" /app/html/index.html &&
    echo '@> end'
}

commonTasks() {
  banner &&
    # setupSSH &&
    setupSwap &&
    setupDOAgent &&
    hostInfo &&
    setupOps
}

productionSetup() {
  commonTasks && echo '@~> 📠 Production [nothing todo]'
}

stagingSetup() {
  commonTasks && echo '@~> 📟 Staging [nothing todo]'
}

case $ENV in
production)
  productionSetup
  ;;
staging)
  stagingSetup
  ;;
*)
  echo "@~> ⚠️ Unknown env $ENV" && ENV=UNKNOWN && commonTasks
  ;;
esac
