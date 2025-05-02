resource "aws_db_subnet_group" "rds_subnets" {
  name       = "rds-subnet-group-tf"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg-tf"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instance_backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS
resource "aws_db_instance" "backend_db_rds" {
  identifier         = "backend-db-rds-tf"
  engine             = "mysql"
  engine_version     = 8.0
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "webapp-rds-mysqldb-tf"
  username           = local.db_creds.username
  password           = local.db_creds.password
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  multi_az               = true
  apply_immediately      = true

  tags = {
    Name = "BackendRDS"
  }
}

# Retrieve Credentials from secrets manager
data "aws_secretsmanager_secret" "rds_creds" {
  name = "rds/mysql"
}

data "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id = data.aws_secretsmanager_secret.rds_creds.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_creds.secret_string)
}

