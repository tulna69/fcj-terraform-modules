output "ec2_security_group_id" {
    value = aws_security_group.for_ec2_instance.id
    description = "The security group id for EC2 instance"
}

output "db_security_group_id" {
    value = aws_security_group.for_rds_instance.id
    description = "The security group id for RDS instance"
}

output "private_subnet_ids" {
  value = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  description = "A list of public subnet ids"
}

output "public_subnet_id" {
  value = aws_subnet.public[0].id
  description = "The id of public subnet"
}