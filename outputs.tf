output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server.private_dns
}

output "instance_security_group_ids" {
  value = aws_instance.app_server.vpc_security_group_ids
}

output "instance_subnet" {
  value = aws_instance.app_server.subnet_id
}

output "instance_security_group_ids" {
  description = "Affiche le keeper de : instance_security_group_ids"
  value = random_id.vpc_id.instance_security_group_ids
}