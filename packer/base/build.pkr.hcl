build {
  name    = "base"
  sources = ["source.digitalocean.ubuntu"]

  provisioner "file" {
    destination = "/tmp/"
    sources      = [
      "files/nginx",
      "files/setup.sh",
      "files/banner"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '@> 🗄️ Files...'",
      "mkdir -p /app/html",
      "cp -v /tmp/setup.sh /app/setup.sh",
      "cp -v -r /tmp/nginx/html /app/",
      "chmod +x /app/setup.sh",
      "chmod +x /app/ && chmod +x /app/html",
      "cp -v /tmp/banner /etc/ssh/banner",
      "echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config",
      "ls -lah /app",
      "echo '@> end'"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '@> 🔒 Credentials...'",
      "ssh-keyscan -t rsa github.com >> $HOME/.ssh/known_hosts",
      "ssh-keyscan -t rsa bitbucket.org >> $HOME/.ssh/known_hosts",
      "ssh-keyscan -t rsa gitlab.com >> $HOME/.ssh/known_hosts",
      "echo '@> end'"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '@> 📦 Install dependencies...'",
      "sudo wget --quiet https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop",
      "sudo chmod +x /usr/local/bin/ctop",
      "apt update -y",
      "apt install nginx docker docker-compose jq -y",
      "apt install -y --only-upgrade $(apt --just-print upgrade | awk 'tolower($4) ~ /.*security.*/ || tolower($5) ~ /.*security.*/ {print $2}' | sort | uniq)",
      "apt autoremove -y",
      "apt clean",
      "ctop -v",
      "nginx -v",
      "docker -v",
      "docker-compose -v",
      "jq --version",
      "echo '@> end'"
    ]
  }

  provisioner "shell" {
    script = "files/install-docker-compose.sh"
  }

  // provisioner "shell" {
  //   inline = [
  //     "echo '@> 🐋 Configure Docker...'",
  //     "echo $DOCKER_TOKEN | docker login ${var.DOCKER_REGISTRY} --username ${var.DOCKER_USER} --password-stdin",
  //   ]

  //   environment_vars = [
  //     "DOCKER_TOKEN=${var.DOCKER_TOKEN}"
  //   ]
  // }

  provisioner "shell" {
    inline = [
      "echo '@> 🈴️ Configure Nginx...'",
      "rm -rf /usr/share/nginx/html && rm -rf /var/www/html",
      "ln -s /app/html /usr/share/nginx/html",
      "ln -s /app/html /var/www/html",
      "cp -v -r /tmp/nginx/shared.d /etc/nginx/",
      "cp -v /tmp/nginx/conf.d/*.conf /etc/nginx/conf.d/",
      "cp -v /tmp/nginx/nginx.conf /etc/nginx/nginx.conf",
      "cp -v /tmp/nginx/default.conf /etc/nginx/sites-available/default",
      "echo '@> end'"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '@> 🛡️ Firewall...'",
      "ufw version",
      "nginx -v",
      "ufw allow 'Nginx Full'",
      "ufw allow OpenSSH",
      "ufw --force enable",
      "ufw status",
      "systemctl status nginx"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '@> 🥽 Versions...'",
      "nginx -v",
      "docker --version",
      "docker-compose --version"
    ]
  }
}
