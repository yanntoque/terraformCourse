/*
loadbalancer*/
resource "aws_elb" "web" {
  name            = "${var.web_app}-webapp"
  subnets         = var.subnets
  security_groups = var.security_groups

  listener{
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  tags = {
    "Terraform" = "true"
  }
}

/*Autoscaling group
from https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html*/
resource "aws_launch_template" "web" {
  name_prefix   =  "${var.web_app}-web"
  image_id      = var.web_image_id
  instance_type = var.web_instance_type

  tags = {
    "Terraform" = "true"
  }
}
/*
 vpc_zone_identifier A list of subnet IDs to launch resources in.
*/
resource "aws_autoscaling_group" "web" {
  availability_zones  = ["eu-west-3a","eu-west-3b"]
  vpc_zone_identifier = var.subnets
  desired_capacity    = var.web_desired_capacity
  max_size            = var.web_max_size
  min_size            = var.web_min_size

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
  }
}
/**
To connect the elb to the autoscaling group
*/
resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  elb                    = aws_elb.web.id
}
