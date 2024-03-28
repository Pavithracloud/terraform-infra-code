module "rds" {
  source = "./modules/rds"
  ProjectName   = var.ProjectName
  environment   = var.environment
  db_name = "postgres"
  subnet_name="private"
  instance_class="db.t3.micro"
  allocated_storage = 20
  rds_username="postgres"
  security_groups_id=["${module.rds_sg.security_group_id.id}"]
  deletion_protection=false
  password="admin123"
  subnet_id=["${module.dev_vpc.private_subnet_1.id}","${module.dev_vpc.private_subnet_2.id}"]
  publicly_accessible = false
  backup_retention_period = 0
  auto_minor_version_upgrade = true
  max_allocated_storage = 0  #for autoscaling storage
    depends_on = [
    module.rds_sg,
    module.dev_vpc
  ]
}

module "rds_sg" {
  source = "./modules/sg"
  ProjectName   = var.ProjectName
  environment   = var.environment
  vpc_id        = "${module.dev_vpc.vpc_id.id}"
  ingress_ports = [5432]
  cidr_blocks = ["0.0.0.0/0"]
  #security_groups_id = [""]
  resource_name = "rds"
}
