# Automação em Terraform de uma Infraestrutura AWS para Web Server e Banco de Dados RDS MySQL

## Descrição

Este projeto utiliza Terraform para provisionar uma infraestrutura na AWS que inclui uma VPC, subnets públicas, um Internet Gateway, tabelas de rotas, grupos de segurança, uma instância EC2 para um servidor web e uma instância de banco de dados MySQL no Amazon RDS. O objetivo é criar um ambiente seguro e escalável para hospedar uma aplicação web e seu banco de dados.

## Estrutura do Projeto

### 1. Provedor AWS Configurado
O provedor AWS foi configurado para definir a região onde os recursos serão provisionados.

### 2. Criação de VPC
Foi criada uma Virtual Private Cloud (VPC) com um bloco CIDR específico, que serve como a rede principal para todos os recursos.

### 3. Configuração de Subnets Públicas
Duas subnets públicas foram criadas, cada uma localizada em uma zona de disponibilidade diferente, permitindo alta disponibilidade e resiliência.

### 4. Implementação de Internet Gateway
Um Internet Gateway foi criado e anexado à VPC, possibilitando o tráfego de entrada e saída da internet.

### 5. Criação de Tabela de Rotas Pública
Uma tabela de rotas pública foi criada, permitindo que o tráfego das subnets públicas seja roteado para o Internet Gateway.

### 6. Associação de Subnets à Tabela de Rotas
As subnets públicas foram associadas à tabela de rotas pública para garantir a conectividade com a internet.

### 7. Configuração de Grupos de Segurança
Dois grupos de segurança foram configurados:
- **Grupo de Segurança Web**: Permite tráfego HTTP na porta 80 para a instância web.
- **Grupo de Segurança do Banco de Dados**: Permite tráfego na porta 3306, restrito à VPC.

### 8. Criação de Instância EC2
Uma instância EC2 foi provisionada para o servidor web, utilizando a primeira subnet pública e o grupo de segurança web.

### 9. Criação de Instância RDS MySQL
Uma instância de banco de dados MySQL foi provisionada no Amazon RDS, utilizando o grupo de segurança do banco de dados e um grupo de subnets.

### 10. Configuração de Grupo de Subnets para o Banco de Dados
Um grupo de subnets foi criado para o banco de dados, incluindo ambas as subnets públicas.

## Requisitos

Antes de executar o projeto, certifique-se de ter os seguintes itens instalados e configurados:

- **Terraform** (versão mais recente)
- **AWS CLI** configurado com suas credenciais

## Variáveis

Este projeto utiliza variáveis para definir os recursos. As principais variáveis que você precisará definir incluem:

- `region`: Região AWS onde os recursos serão provisionados.
- `vpc_cidr`: Bloco CIDR para a VPC.
- `public_subnet_1_cidr`: Bloco CIDR para a primeira subnet pública.
- `public_subnet_2_cidr`: Bloco CIDR para a segunda subnet pública.
- `availability_zone_1`: Primeira zona de disponibilidade.
- `availability_zone_2`: Segunda zona de disponibilidade.
- `ami_id`: ID da AMI para a instância EC2.
- `instance_type`: Tipo da instância EC2.
- `db_allocated_storage`: Espaço alocado para o banco de dados RDS.
- `db_username`: Nome de usuário para o banco de dados.
- `db_password`: Senha para o banco de dados.

Essas variáveis podem ser definidas em um arquivo `terraform.tfvars` ou passadas diretamente na linha de comando.

## Instruções de Execução

1. **Clone o Repositório**
   
   ```bash
   git clone https://github.com/bmsousa1991/terraform_ec2_rds.git
   cd terraform_ec2_rds

2. **Inicialize o Terraform**
   
   ```bash
   terraform init

3. **Crie o Plano de Execução**
   
   ```bash
   terraform plan

4. **Aplique o Plano**
   
   ```bash
   terraform apply

5. **Destrua a Infraestrutura (Opcional)**
    
   ```bash
   terraform destroy

## Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests com melhorias e correções.

