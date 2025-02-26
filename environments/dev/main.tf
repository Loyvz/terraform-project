module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  aws_region_a       = "us-east-1a"
  aws_region_b       = "us-east-1b"
  project_name       = "myproject-dev"
}

module "security_groups" {
  source         = "../../modules/security_groups"
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = module.vpc.vpc_cidr
  allowed_ssh_ip = "193.144.213.153/32"  # ¡Cambia esto por tu IP real!
  project_name  = "myproject-dev"
}

module "ec2" {
  source           = "../../modules/ec2"
  ami_id           = "ami-014d544cfef21b42d" # Reemplázalo con una AMI válida
  instance_type    = "t2.micro"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  public_sg_id     = module.security_groups.public_sg_id
  private_sg_id    = module.security_groups.private_sg_id
  key_pair_name    = "my-key-pair" # Reemplaza con el nombre de tu clave SSH
  project_name     = "myproject-dev"
}

module "rds" {
  source           = "../../modules/rds"
  db_name         = "mydatabase"
  db_username     = "admin"
  db_password     = "SuperSecure123!"
  db_sg_id        = module.security_groups.private_sg_id
  db_subnet_group = module.vpc.db_subnet_group
  project_name    = var.project_name
}
