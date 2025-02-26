output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  value       = aws_db_instance.default.endpoint
}

output "rds_instance_id" {
  description = "ID de la instancia RDS"
  value       = aws_db_instance.default.id
}
