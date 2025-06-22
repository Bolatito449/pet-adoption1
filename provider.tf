provider "aws" {
  region  = "eu-west-1"
  

}
provider "vault" {
  address = "https://vault.bolatitoadegoroye.top"
  token   = "s.iNnzr4aFXPn7QqOoUqVkiCyK"
}

terraform {
  backend "s3" {
    bucket         = "bolatito-bucket-pet-adoption"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-1"
    use_lockfile   = true
    encrypt        = true
  }
}