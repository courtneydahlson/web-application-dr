key_name = "EC2 Tutorial"
ami_id        = "ami-0f88e80871fd81e91"
instance_type = "t2.micro"
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 2
s3_bucket_frontend = "web-application-dr"
certificate_arn = "arn:aws:acm:us-east-1:783764614133:certificate/8f6d651e-df0f-4419-bc01-3aff5ebb2b9d"