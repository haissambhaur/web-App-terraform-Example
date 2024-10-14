module "web_infra_rds" {
    source = "../module/rds"
    
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
    private_subnet_1_id = var.private_subnet_1_id
    private_subnet_2_id = var.private_subnet_2_id
    vpc_id = var.vpc_id
} 

resource "aws_security_group" "webApp"{
  tags = {
    Name = "${var.ENVIRONMENT}-webApp"
  }
  
  name          = "${var.ENVIRONMENT}-webApp"
  description   = "Created by webApp"
  vpc_id        = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

  }

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

#Resource key pair
resource "aws_key_pair" "webApp_key" {
  key_name      = "webApp_key"
  public_key    = file(var.public_key_path)
}

resource "aws_launch_template" "launch_template_webApp" {
  name          = "launch_template_webApp"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.webApp_key.key_name

 user_data = base64encode("#!/bin/bash\nsudo apt-get update -y\nsudo apt-get install -y docker.io\nsudo systemctl start docker\nsudo usermod -aG docker ubuntu\nsudo systemctl enable docker\nsudo docker run -d --name webapp -p 80:3000 haissambhaur/webappterra")

  network_interfaces {
    security_groups = [aws_security_group.webApp.id]
    associate_public_ip_address = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webApp-instance"
    }
  }
}


resource "aws_autoscaling_group" "webApp_ag" {
  name                      = "webApp_ag"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_template {
    id      = aws_launch_template.launch_template_webApp.id
    version = "$Latest"
  }
  vpc_zone_identifier       = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
  target_group_arns         = [aws_lb_target_group.load-balancer-target-group.arn]
}

#Application load balancer for app server
resource "aws_lb" "webApp-load-balancer" {
  name               = "${var.ENVIRONMENT}-webApp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webApp_alb.id]
  subnets            = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]

}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Adding HTTP listener
resource "aws_lb_listener" "webserver_listner" {
  load_balancer_arn = aws_lb.webApp-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

output "load_balancer_output" {
  value = aws_lb.webApp-load-balancer.dns_name
}