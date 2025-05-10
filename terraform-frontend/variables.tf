variable "key_name" {
  description = "The name of the EC2 Key Pair"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
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

variable "s3_bucket_frontend" {
    description = "S3 bucket name"
    type = string
}