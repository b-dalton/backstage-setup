terraform {
  required_version = ">= 1.3.7"
  cloud {
    organization = "bdalton_personal_projects"
    workspaces {
      name = "backstage-setup"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      owner   = "Ben"
      project = "backstage-setup"
      name    = "backstage"
    }
  }
}
