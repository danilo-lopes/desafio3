# Desafio 3

## Projeto

```
.
├── LICENSE
├── README.md
├── ansible
│   ├── ansible.cfg
│   ├── group_vars
│   │   └── all
│   ├── main.yml
│   └── roles
│       ├── database
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── vars
│       │       └── main.yml
│       ├── dependencies
│       │   └── tasks
│       │       └── main.yml
│       ├── nginx
│       │   ├── handlers
│       │   │   └── main.yml
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       ├── blogbiqueirabr.conf
│       │       └── nginx.conf
│       ├── php-fpm
│       │   ├── handlers
│       │   │   └── main.yml
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       └── blog.conf
│       └── wordpress
│           ├── handlers
│           │   └── main.yml
│           ├── tasks
│           │   └── main.yml
│           └── templates
│               └── wp-config.php
├── packer
│   ├── main.json
│   └── scripts
│       ├── clean-up.sh
│       └── install-ansible.sh
└── terraform
    ├── main.tf
    ├── modules
    │   ├── instance
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   └── variables.tf
    │   ├── route53
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   └── variables.tf
    │   └── securitygroup
    │       ├── main.tf
    │       ├── output.tf
    │       └── variables.tf
    ├── modules.tf
    ├── output.tf
    └── variables.tf
```

## Objetivo

O objetivo do projeto é unificar 3 ferramentas: `Terraform`, `Ansible` e `Packer` para no final prover um serviço web, que
no caso, foi um `wordpress`.

## Especificações das ferramenta

### Packer
O `Packer` foi usado para nos prover uma `AMI` que será utilizada no `Terraform` para construção da EC2 que irá prover
o serviço `wordpress`

O build da imagem segue algumas características para prover o wordpress:

* A imagem sera "tageada" com o timestamp gerado

* Tera uma tag com o nome dela

* Usuario de autenticação: `centos`

* No processo de pré build irá instalar o ansible

* Executará roles do projeto do Ansible dentro da imagem

* Após executar as roles do Ansible, executa um script de pós build, que vai remover o Ansible e limpar cache do gerenciador
de pacote do sistema operacional

* Por fim, gera um arquivo de metadados com informações importantes sobre a imagem, como por exemplo o `AMI ID`, tempo
de build da imagem, `builder_type`(amazon-ebs) e `last_run_uuid` (versão mais atual se baseando nos builds que já foram
feitos)

```
{
  "builds": [
    {
      "name": "amazon-ebs",
      "builder_type": "amazon-ebs",
      "build_time": 1590864607,
      "files": null,
      "artifact_id": "us-east-1:ami-0b15495e9a11ad581",
      "packer_run_uuid": "d135c3bb-c424-8df6-6f1a-29f3e7b7b21e",
      "custom_data": null
    }
  ],
  "last_run_uuid": "d135c3bb-c424-8df6-6f1a-29f3e7b7b21e"
}
```

Foi usado para buildar a imagem um `CentOS 7`. Você deve utilizar uma imagem do marketplace da AWS para registrar uma AMI
na sua conta, sendo necessário pegar o `product_code` e o `owner` da imagem. 

Informações:

[Marketplace AWS](https://aws.amazon.com/marketplace)

[Wiki Centos](https://wiki.centos.org/Cloud/AWS)

### Ansible

O projeto do Ansible teve o objetivo de "preparar" a AMI que será gerada pelo Packer. Preparar no sentido de instalar e
configurar serviços para prover o Wordpress.

Foi feito roles para cada camada de necessidade:

`dependencies` : Instalação de pacotes e repositorios necessarios

`php e php-fpm` : Configuração para fazer o FastCGI do site

`nginx` : Configuração necessárias para garantir uma boa operabilidade do serviço e configurar o server block do site

`database` : MySQL. Configuração geral do banco

`wordpress` : Instalação e configuração

obs: A senha do banco está setada direto no role dele. Fique avontade de trocar o lugar caso seja necessario

### Terraform

O projeto terraform tem um papel mais simples. Subir o EC2 com a AMI gerada pelo Packer, criar o securitygroup e fazer
os registros tipo A no `route53` da resolução de dominio para o site do wordpress.

O que vale ressaltar no terraform é que foi usado o recurso `data` para pegar a `AMI ID` no serviço de AMI da nossa conta, baseando-se no
nome e a versão mais atual.

### Getting Started

* Configurar SERCRET KEY e ACCESS KEY da sua conta AWS

* Exportar como variavel de ambiente elas e a AWS Region

`export AWS_ACCESS_KEY=XXXX-YYYYY-ZZZZZ`

`export AWS_SCRET_KEY=ZZZZ-YYYYY-BBBBBB`

`export AWS_REGION=us-east-1`

**Packer:**

`cd packer`

`packer validate main.json` =

***Template validated successfully.***

`packer build main.json` =

***us-east-1: ami-0b15495e9a11ad581***

**Terraform:**

`cd ../terraform`

`terraform init && terraform plan`

`terraform apply --auto-approve` =

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

wordpressDNS = blog.biqueirabr.com.br
wordpressPublicIP = 34.226.246.141

```

### Clean UP

`terraform destroy --auto-approve`

`aws ec2 deregister-image --image-id ami-XXX-YYYY`


Veja no console se o Packer criou `EBS volumes` e `snaphosts` no momento do registro da AMI e os remova.

---