resource "aws_db_subnet_group" "web_infra_subnet_group" {
  name = "${var.ENVIRONMENT}-web_infra_subnet_group"
  description = "a group of subnets which the DB can connect to"
  subnet_ids = [ 
    "${var.private_subnet_1_id}",
    "${var.private_subnet_2_id}",
   ]
   tags = {
     Name = "${var.ENVIRONMENT}-web_infra_subnet_group"
   }
}

resource "aws_security_group" "rds_securityGroup" {
    description = "security group for RDS instances"
    vpc_id = var.vpc_id

    ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-rds_securityGroup"
   }
  
}
resource "aws_db_instance" "web_infra_rds" {
  identifier = "${var.ENVIRONMENT}-web-infra-rds"
  allocated_storage = var.RDS_ALLOCATED_STORAGE
  storage_type = "gp2"
  engine = var.RDS_ENGINE
  engine_version = var.RDS_ENGINE_VERSION
  instance_class = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.RDS_USERNAME
  password = var.RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.rds_securityGroup.id]
  db_subnet_group_name = aws_db_subnet_group.web_infra_subnet_group.name
  multi_az = "false"
  skip_final_snapshot = "true"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.web_infra_rds.endpoint
}