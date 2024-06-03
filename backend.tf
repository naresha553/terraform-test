terraform {
  backend "s3" {
    bucket         = "terraform-state-unique-suffix"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}