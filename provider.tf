provider "aws" {
  region  = "eu-west-2"
}

provider "vault" {
  address = "https://vault.bolatitoadegoroye.top"
  token   = "s.amm7lmQakqbkD7pySH07igDd"
}

terraform {
  backend "s3" {
    bucket       = "tito-bucket-pet-adoption"
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45.0"
    }
  }
}