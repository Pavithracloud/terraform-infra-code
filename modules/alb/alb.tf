# create ALB - Public


resource "aws_lb" "application_lb" {
  name               = "${var.ProjectName}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_id
  subnets            = var.pub_subnet_id

  # enable_deletion_protection = true

  tags = {
    Name        = "${var.ProjectName}-alb-pub-${var.environment}"
    ProjectName = var.ProjectName
    environment = var.environment
  
  }
}

# Target Group for Public ALB

resource "aws_lb_target_group" "ecs-target_group" {
  name        = "${var.ProjectName}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}
# ALB listners Rules

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on = [
    aws_lb_target_group.ecs-target_group
  ]
  listener_arn = aws_lb_listener.alb_listners1.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group.id
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}



resource "aws_lb_listener" "alb_listners1" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"

 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group.arn
  }

  depends_on = [
    aws_lb_target_group.ecs-target_group
  ]
}