terraform {
  backend "s3" {
    bucket = "web-application-dr"
    key    = "terraform/frontend/terraform.tfstate"
    region = "us-east-1"                    
    encrypt = true 
    use_lockfile = true                         
  }
}
