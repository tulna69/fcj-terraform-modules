output "db_address" {
    value = aws_db_instance.this.address
    description = "Database address"
}

output "db_port" {
    value = aws_db_instance.this.port
    description = "Database port"
}

output "db_name" {
    value = aws_db_instance.this.name
    description = "Database name"
}

output "db_username" {
    value = aws_db_instance.this.username
    description = "Database username"
}