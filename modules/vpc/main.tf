# Crear VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnet Pública (Para instancias con acceso a Internet)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.aws_region_a

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Subnet Privada en la AZ1 (Para RDS y servidores sin acceso directo a Internet)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.aws_region_b

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

# Subnet Privada en otra AZ (AZ2) para RDS
resource "aws_subnet" "private_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"  # Puedes cambiarlo si es necesario
  availability_zone       = "us-east-1c"  # Debe ser diferente a la anterior
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-az2"
  }
}

# Internet Gateway (Para permitir tráfico de la Subnet Pública a Internet)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tabla de Rutas Pública (Usa el Internet Gateway)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Asociar Subnet Pública con la Tabla de Rutas Pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP para el NAT Gateway (Para que las instancias privadas tengan Internet)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

# NAT Gateway en la Subnet Pública
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [aws_internet_gateway.gw]
}

# Tabla de Rutas Privada (Usa el NAT Gateway para permitir salida a Internet)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Asociar Subnet Privada 1 con la Tabla de Rutas Privada
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Asociar Subnet Privada 2 con la Tabla de Rutas Privada
resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

# Grupo de Subnets para RDS (Debe incluir al menos dos subnets privadas en diferentes AZs)
resource "aws_db_subnet_group" "this" {
  name       = "my-db-subnet-group"
  subnet_ids = [
    aws_subnet.private.id,    # Subnet privada en AZ1
    aws_subnet.private_az2.id # Subnet privada en AZ2
  ]

  tags = {
    Name = "my-db-subnet-group"
  }
}
