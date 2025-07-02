certificate_arn = "arn:aws:acm:us-west-2:783764614133:certificate/e6a86f00-7b30-4004-85d6-59f56fc6a18a"
ami_id        = "ami-04999cd8f2624f834"
instance_type = "t2.micro"
key_name = "EC2 Tutorial US west 2"
asg_min_size         = 1
asg_max_size         = 1
asg_desired_capacity = 1
s3_bucket_frontend = "web-application-dr-secondary"