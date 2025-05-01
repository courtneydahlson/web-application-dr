variable "region" {
    description = "AWS Region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "VPC cidr block"
    type = string
    default = "10.0.0.0/16"
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type = string
}

variable "asg_max_size" {
    description = "Auto-scaling group maximum amount of instances"
    type = number
    default = 3
}

variable "asg_min_size" {
    description = "Auto-scaling group minimum amount of instances"
    type = number
    default = 1
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "s3_bucket_backend" {
    description = "S3 bucket name"
    type = string
}

variable "key_name" {
  description = "The name of the EC2 Key Pair"
  type        = string
}
