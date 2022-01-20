terraform {
  backend "s3" {
   
    bucket         = "terraform-state-elastify"
    key            = "global/s3/terraform.tfstate"
    region         = "us-west-2"    
    dynamodb_table = "terraform_elastify_locks"
    encrypt        = true
    force_destroy = true
  }
}

