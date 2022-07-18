# Ansible

Automatiza o processo de provisionamento das aplicações.

O processo de provisionamento consiste em gerar um `docker-compose.yml` no servidor do serviço e um arquivo de definição do [NGINX](https://www.nginx.com/) para fazer [proxy reverso](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) para o serviço gerenciado pelo [docker-compose](https://docs.docker.com/compose/).

> Para mais informações sobre o NGINX e Docker instalados no servidor, consultar o [packer](../packer/README.md).

## Comandos

> Este projeto usa o utilitário [`taskfile`](https://taskfile.dev/) para simplificar algumas ações.

Sempre antes de fazer um deploy atualize o inventário.

```sh
task inventory
```
Também é possivel encadear comandos.

```sh
task inventory deploy:discourse
```

Para conhecer os comandos disponíveis use o opção `--list`

```sh
task --list
```

## Secredos

Este projeto usa [ansible-vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) para proteger as alguns valores secretos.

A senha fica no arquivo `.vault.pass.txt`, este arquivo nunca pode ser versionado.

```sh
ansible-vault encrypt vars/.secrets.$ENV.yml 
```

## Primeiro deploy

O primeiro deploy vai demorar alguns minutos, pois todas as *migrations* e *builds* serão executados neste momento.