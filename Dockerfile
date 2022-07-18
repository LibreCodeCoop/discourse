# syntax=docker/dockerfile:1
FROM ubuntu:21.10 as base
RUN apt update -y

FROM base as dowloader

RUN apt install curl unzip tar gzip git ca-certificates openssh-client -y

# Terraform download
ARG TERRAFORM_VER
RUN cd /tmp && \
  curl https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip --output terraform.zip && \
  unzip terraform.zip && \
  mv terraform /usr/bin/ && \
  rm -rf /tmp/* && \
  terraform --version

ARG PACKER_VER
RUN cd /tmp && \
  curl https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip --output packer.zip && \
  unzip packer.zip && \
  mv packer /usr/bin/ && \
  rm -rf /tmp/* && \
  packer version

ARG DOCTL_VER
RUN cd /tmp && \
  curl -L https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VER}/doctl-${DOCTL_VER}-linux-amd64.tar.gz --output doctl.tar.gz && \
  ls -la /tmp && \
  tar xf doctl.tar.gz -C /tmp && \
  mv /tmp/doctl /usr/bin/doctl && \
  rm -rf /tmp/* && \
  doctl version

# Install task (https://taskfile.dev)
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/bin \
  && task --version

# Generate private key
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa

# Target
FROM base

# configure nodejs repository
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install ca-certificates ssh nodejs ansible -y

# Workdir
RUN mkdir -p /project
WORKDIR /project

# Terraform cache
ENV TF_PLUGIN_CACHE_DIR=/project/.tmp/.terraform.d/plugin-cache
ENV PACKER_CONFIG_DIR=/project/.tmp/
# ENV PACKER_CACHE_DIR=/project/.tmp/.packer.d

# Bash improviments
RUN echo "alias ll='ls -l'" >> /root/.bashrc && \
  echo "complete -C /usr/bin/terraform terraform" >> /root/.bashrc && \
  echo 'PS1="\n\[\e[0;31m\]┌─[\[\e[0m\]\[\e[1;33m\]\u\[\e[0m\] ܁\[\e[1;36m\]\[\e[0m\]\[\e[1;34m\]\w\[\e[0m\]\[\e[0;31m\]]\n\[\e[0;31m\]└─\e[0;31m\]$ \[\e[0m\]"' >> /root/.bashrc

# Copy from downloader stage
COPY --from=dowloader --chown=root:root /root/.ssh/ /root/.ssh/
COPY --from=dowloader --chown=root:root /usr/bin/terraform /usr/bin/terraform
COPY --from=dowloader --chown=root:root /usr/bin/packer /usr/bin/packer
COPY --from=dowloader --chown=root:root /usr/bin/doctl /usr/bin/doctl
COPY --from=dowloader --chown=root:root /usr/bin/task /usr/bin/task

# prepare ssh
RUN chmod 600 /root/.ssh/id_rsa && \
  ssh-keyscan -H github.com >> /root/.ssh/known_hosts && \
  ssh-keyscan -H bitbucket.com >> /root/.ssh/known_hosts && \
  echo "StrictHostKeyChecking no" >> /root/.ssh/ssh_config

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 600 /docker-entrypoint.sh && \
  chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]
