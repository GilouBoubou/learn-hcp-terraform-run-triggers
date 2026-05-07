output "instance_hostname_1" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server_1.private_dns
}

output "instance_security_group_ids_1" {
  value = aws_instance.app_server_1.vpc_security_group_ids
}

output "instance_subnet_1" {
  value = aws_instance.app_server_1.subnet_id
}

output "ssh_key_pair_name" {
  value = var.key_name
}
