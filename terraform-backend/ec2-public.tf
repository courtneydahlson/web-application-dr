#EC2 Instance in Public Subnet
resource "aws_instance" "web" {
  ami                    = "ami-0e449927258d45bc4"  # Example Amazon Linux 2 AMI (verify region)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.instance_backend_sg.id]
  associate_public_ip_address = true  # 👈 Ensure public IP (if map_public_ip_on_launch is false)
  key_name               = "your-key-name"  # Replace with your EC2 key pair

  tags = {
    Name = "PublicEC2"
  }
}