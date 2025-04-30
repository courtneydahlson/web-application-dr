# #VPC
# resource "aws_vpc" "main" {
#     cidr_block = var.vpc_cidr_block
#     enable_dns_support = true
#     enable_dns_hostnames = true
#     tags = { Name = "main-vpc"}
# }

# # Private Subnets
# resource "aws_subnet" "private_subnet_1" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = "10.0.1.0/24"
#     availability_zone = "${var.region}a"
#     tags = { Name = "private-subnet-1" }
# }

# resource "aws_subnet" "private_subnet_2" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "${var.region}b"
#     tags = { Name = "private-subnet-2" }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
# }

# # Creates a route table for the private subnets.
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id
# }

# # Associates the private subnets with the route table.
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.private_subnet_1.id
#   route_table_id = aws_route_table.private_rt.id
# }
# resource "aws_route_table_association" "b" {
#   subnet_id      = aws_subnet.private_subnet_2.id
#   route_table_id = aws_route_table.private_rt.id
# }

# #Security Group EC2 instance
# resource "aws_security_group" "instance_backend_sg" {
#   name        = "instance-backend-sg-tf"
#   description = "Allow SSH"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr_block] 
#   }

#   ingress {
#     description = "Allow HTTP traffic from ALB"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = [aws_security_group.alb_backend_sg.id]
#   }

#     ingress {
#     description = "Allow HTTPS traffic from ALB"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     security_groups = [aws_security_group.alb_backend_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# # Security group ALB
# resource "aws_security_group" "alb_backend_sg" {
#     name = "alb-backend-sg-tf"
#     description = "Allow inboud and outbound traffic"
#     vpc_id = aws_vpc.main.id

#     ingress {
#         description = "Allow HTTP traffic from ALB"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }

# # Internal ALB
# resource "aws_lb" "backend_alb" {
#   name               = "backend-alb-tf"
#   internal           = true
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_backend_sg.id]
#   subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
# }