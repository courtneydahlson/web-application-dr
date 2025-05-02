# ASG
resource "aws_autoscaling_group" "backend_asg" {
  name                 = "backend-asg-tf"
  desired_capacity     = var.asg_desired_capacity
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  vpc_zone_identifier  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.backend_tg.arn]

  tag {
    key                 = "Name"
    value               = "Backend"
    propagate_at_launch = true
  }
}

# IAM role for ec2 to access S3
resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2-s3-access-role-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# S3 Policy
resource "aws_iam_policy" "s3_access_policy" {
  name = "ec2-s3-access-policy-tf"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_backend}",
          "arn:aws:s3:::${var.s3_bucket_backend}/*"
        ]
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}


#Instance profile to attach IAM role to EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile_backend" {
  name = "ec2-s3-instance-profile-backend-tf"
  role = aws_iam_role.ec2_s3_access.name
}


# Launch Template
resource "aws_launch_template" "backend" {
  name_prefix   = "backend-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "EC2 Tutorial"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile_backend.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance_backend_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(file("user_data.sh"))
}