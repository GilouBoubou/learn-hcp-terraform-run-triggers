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

output "ssh_key_pair_name" {
  value = aws_key_pair.instance_keypair.key_name
}

output "ssh_private_key_file" {
  value = local_file.private_key.filename
}

output "ssh_private_key_pem" {
  value     = tls_private_key.instance_key.private_key_pem
  sensitive = true
}
