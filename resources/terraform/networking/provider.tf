terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket  = "shurgentum-tfstate"
    key     = "eks.tfstate"
    region  = "eu-central-1"
    profile = "shurgentum"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.default_region
  profile = "shurgentum"
  default_tags {
    tags = {
      managed_by = "Terraform"
      Project    = "EKS"
    }
  }
}
