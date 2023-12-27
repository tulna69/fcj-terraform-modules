locals {
  http_port       = 80
  https_port      = 443
  custom_tcp_port = 5000
  ssh_port        = 22
  db_port         = 3306
  tcp_protocol    = "tcp"
  all_ips         = "0.0.0.0/0"
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public.ids[0]
  vpc_security_group_ids = [aws_security_group.web_server.id]

  tags = {
    Name = "${var.env}-first-cloud-app-server"
  }
}

resource "aws_security_group" "web_server" {
  name        = "${var.env}-web-server-sg"
  description = "Security group for web server"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "${var.env}-web-server-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  security_group_id = aws_security_group.web_server.id

  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol = local.tcp_protocol
  cidr_ipv4   = local.all_ips
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress" {
  security_group_id = aws_security_group.web_server.id

  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = local.tcp_protocol
  cidr_ipv4   = local.all_ips
}

resource "aws_vpc_security_group_ingress_rule" "custom_tcp_ingress" {
  security_group_id = aws_security_group.web_server.id

  from_port   = local.custom_tcp_port
  to_port     = local.custom_tcp_port
  ip_protocol = local.tcp_protocol
  cidr_ipv4   = local.all_ips
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.web_server.id

  from_port   = local.ssh_port
  to_port     = local.ssh_port
  ip_protocol = local.tcp_protocol
  cidr_ipv4   = local.all_ips
}
