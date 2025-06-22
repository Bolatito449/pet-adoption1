provider "aws" {
  region  = "eu-west-2"
  profile = "myprofile"
}

terraform {
  backend "s3" {
    bucket       = "tito-bucket-pet-adoption"
    key          = "vault-jenkins/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    profile      = "myprofile"
    use_lockfile = true
  }
}
