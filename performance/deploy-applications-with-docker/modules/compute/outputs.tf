output "public_ip" {
    value = aws_instance.this.public_ip
    description = "EC2 instance public IPv4"
}