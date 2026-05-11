terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.76.2"
    }
  }

  required_version = ">= 1.2"
}
