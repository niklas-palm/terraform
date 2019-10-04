# Create ami

data "aws_ami" "myOwnAMI" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["terraT*"]
  }
}

# Create launch config

resource "aws_launch_configuration" "as_conf" {
  name = "terraform-launch-config"
  image_id      = "${data.aws_ami.myOwnAMI.id}"
  instance_type = "t2.micro"
  security_groups    = ["${aws_security_group.web_server.id}"]
#   user_data       = "${file("user_data.txt")}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create autoscale group

resource "aws_autoscaling_group" "as_group" {
  name                 = "terraform-asg-example"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  vpc_zone_identifier = ["${aws_subnet.privsub_A.id}", "${aws_subnet.privsub_B.id}"]
  min_size             = 2
  max_size             = 5

  lifecycle {
    create_before_destroy = true
  }
}

# Create a new ALB Target Group attachment

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.as_group.id}"
  alb_target_group_arn   = "${aws_lb_target_group.target_group.arn}"

  depends_on = ["aws_lb_target_group.target_group", "aws_autoscaling_group.as_group"]
}

# Create scaling policy
resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "as-scale-policy"
#   scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
#   cooldown               = 120
  autoscaling_group_name = "${aws_autoscaling_group.as_group.name}"
  policy_type           = "TargetTrackingScaling"

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }

  target_value = 40.0
}
}