resource "aws_security_group" "sg" {
  name= "${var.ProjectName}-${var.resource_name}-sg-${var.environment}"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks
        security_groups = var.security_groups_id
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   tags = {
    Name        = "${var.ProjectName}-${var.resource_name}-sg-${var.environment}"
    ProjectName = var.ProjectName
    environment = var.environment
  }
}











