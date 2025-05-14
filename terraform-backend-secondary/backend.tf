terraform {
  backend "s3" {
    bucket = "web-application-dr-secondary"
    key    = "terraform/backend/terraform.tfstate"
    region = "us-west-2"                    
    encrypt = true 
    use_lockfile = true                         
  }
}