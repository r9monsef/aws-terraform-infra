terraform {
  backend "s3" {
    bucket         = "reza-stage-terraform-state"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-stage"
    encrypt        = true
  }
}
