resource "aws_security_group" "webApp_alb" {
  tags = {
    Name = "${var.ENVIRONMENT}-webApp_alb"
  }
  name = "${var.ENVIRONMENT}-webApp_alb"
  description = "Created by webApp"
  vpc_id      = var.vpc_id 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}