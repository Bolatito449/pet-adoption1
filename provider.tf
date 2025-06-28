provider "aws" {
  region  = "eu-west-2"
}

provider "vault" {
  address = "https://vault.bolatitoadegoroye.top"
  token   = "s.XfSdwKWJA2k1kgEaXqP8IlZ2"
}

terraform {
  backend "s3" {
    bucket       = "tito-bucket-pet-adoption"
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}