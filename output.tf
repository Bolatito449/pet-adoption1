output "bastion-public-ip" {
  value = module.bastion.bastion_public_ip
}

output "nexus_ip" {
  value = module.nexus.nexus_ip
}
output "nexus_private_ip" {
  value = module.nexus.nexus_private_ip
}

output "ansible-server-ip" {
  value = module.ansible.ansible_ip
}

output "sonarqube_public_ip" {
  value = module.sonarqube.sonarqube_public_ip
}

output "DB-endpoint" {
  value = module.database.db_endpoint
}