# Security group ALB
resource "aws_security_group" "alb_backend_sg" {
    name = "alb-backend-sg-tf"
    description = "Allow inboud and outbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "Allow HTTP traffic from ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTP traffic from ALB"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Internal ALB
resource "aws_lb" "backend_alb" {
  name               = "backend-alb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_backend_sg.id]
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# Target Group
resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    }
}

# Listener that listens for connections on port 8080 and forwards the request to a target group
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}