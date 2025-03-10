terraform {
  backend "s3" {
    bucket         = "terraform-backend-state-gvelez"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
