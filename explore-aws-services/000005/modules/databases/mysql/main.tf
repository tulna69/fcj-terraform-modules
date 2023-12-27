# ---------------------------------------------------------------------------------------------------------------------
# RESOURCES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_instance" "main" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password
}

resource "aws_db_subnet_group" "main" {
  name_prefix = "${var.env}-db-sng"
  subnet_ids  = data.aws_subnets.private

  tags = {
    Name = "${var.env}-db-sng"
  }
}
