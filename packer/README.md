# Packer

Criação de imagens base para serem usadas na criação de novos droplets/vms

## Requisitos

- [Packer](https://packer.io)

## Commands

Todo processo de criação foi abstraido pelo script [`build.sh`](build.sh)

```
./build.sh
```

> A unica imagem disponível no momento é a imagem base.

## Public and Private Keys

DISABLED

```
ssh-keygen -C "librecode@base.machine" -t rsa -f ./id_rsa
```

### Public Key

DISABLED

```
ssh-rsa ... librecode@base.machine
```