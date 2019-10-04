resource "aws_security_group" "web_server" {
  name = "web_server"
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  ingress {
    protocol    = "http"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name = "alb_secGroup"
  vpc_id = "${aws_vpc.TerraformVPC.id}"


  ingress {
    protocol    = "http"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}