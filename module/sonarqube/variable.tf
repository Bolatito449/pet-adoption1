variable "keypair" {}
variable "name" {}
variable "subnet_id" {}
variable "bastion_sg" {}
variable "vpc_id" {}
variable "domain" {
  default = "bolatitoadegoroye.top"
}
variable "public_subnets" {}
variable "acm_certificate_arn" {}
variable "route53_zone_id" {}
variable "nr-key" {}
variable "nr-acc-id" {}
# variable "auto_acm_cert" {}

