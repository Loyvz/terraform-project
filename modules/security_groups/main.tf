# Security Group para la Subnet Pública (Permitirá acceso desde tu IP)
resource "aws_security_group" "public_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip] # Solo tu IP puede acceder por SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfico HTTP desde cualquier lado
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfico HTTPS desde cualquier lado
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir cualquier tráfico de salida
  }

  tags = {
    Name = "${var.project_name}-public-sg"
  }
}

# Security Group para la Subnet Privada
resource "aws_security_group" "private_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr] # Permitir tráfico solo dentro de la VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfico de salida a través del NAT Gateway
  }

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}
