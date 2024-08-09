provider "aws" {
  region = var.region
}

# Cria uma VPC (Virtual Private Cloud) com o bloco CIDR especificado.
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

# Cria a primeira subnet pública dentro da VPC, especificando o CIDR e a zona de disponibilidade.
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "public-subnet-1"
  }
}

# Cria a segunda subnet pública dentro da VPC, em uma outra zona de disponibilidade.
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "public-subnet-2"
  }
}

# Cria um Internet Gateway para permitir a comunicação da VPC com a internet.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Cria uma tabela de rotas pública que direciona o tráfego para o Internet Gateway.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associa a primeira subnet pública à tabela de rotas pública.
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associa a segunda subnet pública à tabela de rotas pública.
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Cria um grupo de segurança para a instância web, permitindo tráfego HTTP na porta 80.
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Cria um grupo de segurança para o banco de dados, permitindo tráfego na porta 3306 apenas da VPC.
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# Cria uma instância EC2 para o servidor web, utilizando a primeira subnet pública e associando o grupo de segurança web.
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-instance"
  }
}

# Cria uma instância de banco de dados MySQL na AWS RDS, associando o grupo de segurança do banco de dados e utilizando o grupo de subnets.
resource "aws_db_instance" "wordpress" {
  allocated_storage    = var.db_allocated_storage
  engine               = "mysql"
  engine_version       = "8.0.35"  # Versão válida
  instance_class       = "db.t3.micro"  # Classe válida
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "wordpress-db"
  }
}

# Cria um grupo de subnets para o banco de dados, incluindo as duas subnets públicas.
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "main"
  }
}
