#EC2 Instance in Public Subnet
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.instance_backend_sg.id]
  associate_public_ip_address = true
  key_name               = "EC2 Tutorial US west 2"

  tags = {
    Name = "PublicEC2"
  }
}