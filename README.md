# LibreCode - Discourse

Esta infra é construída com [Packer](https://www.packer.io/), [Terraform](https://www.terraform.io/) e [Ansible](https://docs.ansible.com/)

Terraform e Packer se comunicam com a [DigitalOcean](https://www.digitalocean.com/) para construir toda a infra necessária.

Packer é o responsável por criar a imagem base que será usada nas máquinas que vão rodar os serviços.

O Terraform usa a imagem base para subir as máquinas (vazias)

Ansible é o responsável por provisionar a aplicação nos servidores criados pelo terraform.

Para mais informações, consulte as subpastas deste projeto.

- [packer](packer/README.md)
- [terraform](terraform/README.md)
- [ansible](ansible/README.md)

## Requisitos

- [Docker ~v20.10](https://docs.docker.com/engine/install/)
- [Docker Compose ~v2.3](https://docs.docker.com/compose/cli-command/)

## Comandos

Todas as dependencias necessárias para trabalhar com a infra estão dentro do [`Dockerfile`](Dockerfile) deste projeto.

Basta construir a imagem e executar o container com os comandos abaixo.

> Lembre-se de gerar suas credenciais da DigitalOcean e criar o arquivo `.env` com base no `.env.example`

```sh
docker-compose build
docker-compose run tooling
```
