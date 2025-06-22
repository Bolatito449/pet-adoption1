provider "aws" {
  region  = "eu-west-1"
  profile = "myprofile"
}

terraform {
  backend "s3" {
    bucket       = "bolatito-bucket-pet-adoption"
    key          = "vault-jenkins/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    profile      = "myprofile"
    use_lockfile = true
  }
}
