output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "nexus_ip" {
  value = module.nexus.nexus_ip
}
output "nexus_private_ip" {
  value = module.nexus.nexus_private_ip
}

output "ansible_ip" {
  value = module.ansible.ansible_ip
}

output "sonarqube-ip" {
  value = module.sonarqube.sonarqube-ip
}

output "db_endpoint" {
  value = module.database.db_endpoint
}