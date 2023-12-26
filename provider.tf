terraform {
  backend "s3" {
    bucket = "backend-tf001"
    key    = "global/TFstate_files/terraform.tfstate"
    dynamodb_table = "state_lock"
    region = "eu-west-2"
    encrypt = true
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  }
}
provider "aws" {
  region = var.region
}