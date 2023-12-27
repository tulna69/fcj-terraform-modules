output "address" {
  value       = aws_db_instance.main.address
  description = "Connect to the database at this endpoint"
}
