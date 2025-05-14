terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = var.region
}

provider "aws" {
    alias = "primary"
    region = var.region
}
