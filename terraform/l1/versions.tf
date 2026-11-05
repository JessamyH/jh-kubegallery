terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "jessamy-lab-tfstate-956519721376"
    key          = "jh-kubegallery/l1/terraform.tfstate"
    region       = "ap-southeast-2"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Project   = "jh-kubegallery"
      Layer     = "l1"
      ManagedBy = "terraform"
    }
  }
}
