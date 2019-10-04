
# Create target group

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.TerraformVPC.id}"
}

# Create ALB
resource "aws_lb" "alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${aws_subnet.pubsub_A.id}", "${aws_subnet.pubsub_B.id}"]
}

# Create ALB listener
resource "aws_lb_listener" "forward_to_target_group" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }

  depends_on = ["aws_lb_target_group.target_group"]
}

output "ALB_DNS" {
  value = aws_lb.alb.dns_name
  description = "The DNS of the load balancer."
}


