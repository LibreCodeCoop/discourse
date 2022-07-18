# Terraform

Cria a infra estrutura (máquinas, bancos e afins) dos projetos da LibreCoop/DBSeller

> A aplicação é criada via [`ansible`](../ansible/README.md)

## Pré-Requisitos

Se esta criando o projeto do zero absoluto, verifique o arquivo [`provider.tf`](provider.tf), tenha certeza que o space configurado ali existe e esta na região certa.

Caso necessário, crie um space novo, tente não mudar a região.

Além disso, garanta que o [`packer`](../packer/README.md) já foi executado e gerou a imagem base.

### Comandos

```sh
# inicia o terraform e seu estado.
terraform init

# seleciona o workspace de produção
terraform workspace select production

# verifica o status das alterações
terraform plan

# aplica as alterações
terraform apply
```

> Projetos novos precisam criar o workspace na primeira vez
> `terraform workspace new production`

#### Output

O output do terraform contem informações relevantes do seu estado.

Use esta informação com refeencias para confirgurações de DNS e relacionados.

## Banco de dados

Após criado o banco de dados, verifique as credenciais diretamente no painel da Digital Ocean.

## DNS

Este projeto gera apenas uma máquina.

Ao terminar de criar a máquina basta pegar o IPv4 gerado e usar no registro de DNS.

Uma possibilidade é reservar um IP e após a criação da máquina anexar este IP ao droplet.
Isso previne problemas de propagação de DNS.