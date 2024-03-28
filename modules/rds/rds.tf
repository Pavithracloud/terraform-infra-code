resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.ProjectName}-${var.subnet_name}-${var.environment}"
  subnet_ids = var.subnet_id
  tags = {
    Name       = "${var.ProjectName}-${var.subnet_name}-${var.environment}"
    ProjectName = var.ProjectName
    environment = var.environment
  }
}


# DB parameter Group Name

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.ProjectName}-${var.db_parameter_group_name}-${var.environment}"
  family = "postgres14"
}

# DB instance - RDS postgres

resource "aws_db_instance" "db_instance" {
  allocated_storage = var.allocated_storage
  identifier        = "${var.ProjectName}-rds-${var.environment}"
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "14"
  #instance_class       = "db.t3.medium"
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.rds_username
  password               = var.password
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  port                   = "5432"
  deletion_protection    = var.deletion_protection
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = var.security_groups_id
  publicly_accessible    =var.publicly_accessible
  skip_final_snapshot    = true
  backup_retention_period = var.backup_retention_period
  auto_minor_version_upgrade=var.auto_minor_version_upgrade
  max_allocated_storage = var.max_allocated_storage
  apply_immediately= true


  depends_on = [
    aws_db_parameter_group.db_parameter_group,
    aws_db_subnet_group.db_subnets
  ]
  
    tags = {
    Name = "${var.ProjectName}-rds-${var.environment}"
    environment = var.environment

  }
  
}
