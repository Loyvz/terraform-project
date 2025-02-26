# Instancia EC2 en la Subnet Pública
resource "aws_instance" "public_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_id
  vpc_security_group_ids = [var.public_sg_id]
  key_name        = var.key_pair_name

  tags = {
    Name = "${var.project_name}-public-ec2"
  }
}

# Instancia EC2 en la Subnet Privada
resource "aws_instance" "private_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name        = var.key_pair_name

  tags = {
    Name = "${var.project_name}-private-ec2"
  }
}
