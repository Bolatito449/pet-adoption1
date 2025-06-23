locals {
  name = "tito-ad"
}

module "vpc" {
  source = "./module/vpc"
  name   = local.name
  az1    = "eu-west-2a"
  az2    = "eu-west-2b"
}
provider "aws" {
  alias  = "paris"
  region = "eu-west-2"
}
data "aws_acm_certificate" "auto_acm_cert" {
  domain              = "bolatitoadegoroye.top"
  statuses            = ["ISSUED"]
  most_recent         = true
  types               = ["AMAZON_ISSUED"]
  key_types           = ["RSA_2048"]
}

data "aws_route53_zone" "zone" {
  name         = "bolatitoadegoroye.top"
  private_zone = false
}

module "sonarqube" {
  source              = "./module/sonarqube"
  keypair             = module.vpc.public_key
  name                = local.name
  subnet_id           = module.vpc.pub_sub1_id
  bastion_sg          = module.bastion.bastion_sg
  vpc_id              = module.vpc.vpc_id
  domain              = var.domain
  public_subnets      = [module.vpc.pub_sub1_id, module.vpc.pub_sub2_id]
  nr_key              = var.nr_key
  nr_acct_id          = var.nr_acct_id
  route53_zone_id     = data.aws_route53_zone.zone.zone_id
  acm_certificate_arn = data.aws_acm_certificate.auto_acm_cert.arn
  auto_acm_cert       = data.aws_acm_certificate.auto_acm_cert.arn
}

# module "bastion" {
#   source     = "./module/bastion"
#   name       = local.name
#   keypair    = module.vpc.public_key
#   privatekey = module.vpc.private_key
#   vpc        = module.vpc.vpc_id
#   security_groups = [aws_security_group.bastion-sg.id]
#   bastion_sg = aws_security_group.bastion-sg.id
#   subnets    = [module.vpc.pub_sub1_id, module.vpc.pub_sub2_id]
# }

module "bastion" {
  source     = "./module/bastion"
  name       = local.name
  vpc        = module.vpc.vpc_id
  keypair    = module.vpc.public_key
  subnets    = [module.vpc.pub_sub1_id, module.vpc.pub_sub2_id]
  privatekey = module.vpc.private_key
  security_groups = [aws_security_group.bastion-sg.id]
  bastion-sg = [aws_security_group.bastion-sg.id]
}

module "nexus" {
  source    = "./module/nexus"
  subnet-id = module.vpc.pub_sub1_id
  keypair   = module.vpc.public_key
  name      = local.name
  vpc       = module.vpc.vpc_id
  bastion-sg = module.bastion.bastion-sg
  domain    = var.domain
  subnet1_id = module.vpc.pub_sub1_id
  subnet2_id = module.vpc.pub_sub2_id
  acm_certificate_arn = data.aws_acm_certificate.auto_acm_cert.arn
  nr-key = var.nr_key
  nr-id = var.nr_acct_id
}

module "database" {
  source      = "./module/database"
  name        = local.name
  pri-sub-1   = module.vpc.pri_sub1_id
  pri-sub-2   = module.vpc.pri_sub2_id
  bastion = module.bastion.bastion_sg
  vpc-id      = module.vpc.vpc_id
  stage-sg    = module.stage-envi.stage-sg
  prod-sg     = module.prod-envi.prod-sg
}

module "ansible" {
  source    = "./module/ansible"
  name      = local.name
  keypair   = module.vpc.public_key
  subnet_id = module.vpc.pri_sub1_id
  vpc       = module.vpc.vpc_id
  bastion_key   = module.bastion.bastion_sg
  private_key = module.vpc.private_key
  nexus_ip = module.nexus.nexus_ip
  nr_key = var.nr_key
  nr_acct_id = var.nr_acct_id
}

module "prod-envi" {
  source       = "./module/prod-envi"
  name         = local.name
  vpc-id       = module.vpc.vpc_id
  bastion_sg   = module.bastion.bastion_sg
  key-name     = module.vpc.public_key
  pri_subnet1  = module.vpc.pri_sub1_id
  pri_subnet2  = module.vpc.pri_sub2_id
  pub_subnet1  = module.vpc.pub_sub1_id
  pub_subnet2  = module.vpc.pub_sub2_id
  acm-cert-arn = data.aws_acm_certificate.auto_acm_cert.arn
  domain       = var.domain
  nexus_ip     = module.nexus.nexus_ip
  nr_key       = var.nr_key
  nr_acct_id   = var.nr_acct_id  
  ansible      =  module.ansible.ansible_sg
}

module "stage-envi" {
  source       = "./module/stage-envi"
  name         = local.name
  vpc-id       = module.vpc.vpc_id
  bastion_sg   = module.bastion.bastion_sg
  key-name     = module.vpc.public_key
  pri_subnet1  = module.vpc.pri_sub1_id
  pri_subnet2  = module.vpc.pri_sub2_id
  pub_subnet1  = module.vpc.pub_sub1_id
  pub_subnet2  = module.vpc.pub_sub2_id
  acm-cert-arn = data.aws_acm_certificate.auto_acm_cert.arn
  domain       = var.domain
  nexus_ip     = module.nexus.nexus_ip
  nr_key       = var.nr_key
  nr_acct_id   = var.nr_acct_id  
  ansible      =  module.ansible.ansible_sg
}
