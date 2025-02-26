output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "db_subnet_group" {
  value = aws_db_subnet_group.this.id
}
