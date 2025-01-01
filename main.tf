resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc.id
  target_type = var.target_type

  health_check {
    enabled             = var.health_check.enabled
    path                = var.health_check.path
    matcher             = var.health_check.matcher
    protocol            = var.health_check.protocol
    port                = var.health_check.port
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }
}

module "listener_rules" {
  source           = "app.terraform.io/ptonini-org/ec2-loadbalancer-listener-rule/aws"
  version          = "~> 1.0.0"
  for_each         = var.listener_rules
  target_group_arn = aws_lb_target_group.this.arn
  priority         = each.key
  listener_arn     = each.value.listener_arn
  type             = each.value.type
  redirects        = each.value.redirects
  conditions       = each.value.conditions
}

resource "aws_lb_target_group_attachment" "this" {
  for_each          = var.target_ids
  target_group_arn  = aws_lb_target_group.this.arn
  target_id         = each.value
  availability_zone = var.target_type == "ip" ? "all" : null
}

resource "aws_autoscaling_attachment" "this" {
  for_each               = var.autoscaling_groups
  autoscaling_group_name = each.value
  lb_target_group_arn    = aws_lb_target_group.this.arn
}