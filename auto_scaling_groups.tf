# resource "aws_autoscaling_group" "frontend_asg" {
#   name = "${var.project_name}-Frontend-ASG"

#   desired_capacity = var.desired_capacity
#   min_size         = var.min_size
#   max_size         = var.max_size

#   vpc_zone_identifier = [
#     aws_subnet.frontend_subnet_a.id,
#     aws_subnet.frontend_subnet_b.id
#   ]

#   target_group_arns = [
#     aws_lb_target_group.frontend_target_group.arn
#   ]

#   launch_template {
#     id      = aws_launch_template.frontend_launch_template.id
#     version = "$Latest"
#   }

#   health_check_type         = "ELB"
#   health_check_grace_period = 300

#   tag {
#     key                 = "Name"
#     value               = "${var.project_name}-Frontend-ASG-Instance"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_group" "backend_asg" {
#   name = "${var.project_name}-Backend-ASG"

#   desired_capacity = var.desired_capacity
#   min_size         = var.min_size
#   max_size         = var.max_size

#   vpc_zone_identifier = [
#     aws_subnet.backend_subnet_a.id,
#     aws_subnet.backend_subnet_b.id
#   ]

#   target_group_arns = [
#     aws_lb_target_group.backend_target_group.arn,
#   ]

#   launch_template {
#     id      = aws_launch_template.backend_launch_template.id
#     version = "$Latest"
#   }

#   health_check_type         = "ELB"
#   health_check_grace_period = 300

#   tag {
#     key                 = "Name"
#     value               = "${var.project_name}-Backend-ASG-Instance"
#     propagate_at_launch = true
#   }
# }