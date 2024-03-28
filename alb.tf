module "alb" {
  source             = "./modules/alb"
  ProjectName        = var.ProjectName
  environment        = var.environment
  security_groups_id = ["${module.alb_sg.security_group_id.id}"]
  pub_subnet_id      = ["${module.dev_vpc.public_subnet_1.id}","${module.dev_vpc.public_subnet_2.id}"]
  vpc_id             = "${module.dev_vpc.vpc_id.id}"

  depends_on = [
    module.alb_sg,
    module.dev_vpc
  ]

}


module "alb_sg" {
  source        = "./modules/sg"
  ProjectName   = var.ProjectName
  environment   = var.environment
  vpc_id        = "${module.dev_vpc.vpc_id.id}"
  ingress_ports = [80, 443]
  cidr_blocks   = ["0.0.0.0/0"]
  resource_name = "alb"

}
