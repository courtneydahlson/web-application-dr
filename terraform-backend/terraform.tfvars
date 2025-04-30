region = "us-east-1"
vpc_cidr_block = "10.0.0.0/16"
ami_id        = "ami-0e449927258d45bc4"
instance_type = "t2.micro"
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 2
s3_bucket_backend = "web-application-dr"