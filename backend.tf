terraform {
  backend "s3" {
    bucket = "aws-fms-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    
    # Enable encryption at rest
    encrypt = true
    
    # Enable state locking via DynamoDB
    dynamodb_table = "terraform-state-lock"
  }
} 