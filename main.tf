provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "tfe_outputs" "source_workspace" {
  workspace    = var.workspace_name
  organization = var.organization_name
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.instance_keypair.key_name

  vpc_security_group_ids = data.tfe_outputs.source_workspace.nonsensitive_values.instance_security_group_ids
  subnet_id              = data.tfe_outputs.source_workspace.nonsensitive_values.instance_subnet

  tags = {
    Name = var.instance_name
  }
}

resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_keypair" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.instance_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.instance_key.private_key_pem
  filename        = "${path.module}/id_rsa_${var.instance_name}"
  file_permission = "0600"
}
