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

  user_data = <<-EOF
    #!/bin/bash
    # Préparer le volume et y poser la clé privée
    mkdir -p /mnt/sshkeys
    mount /dev/sdf /mnt/sshkeys || true
    if ! grep -qs '/mnt/sshkeys' /proc/mounts; then
      mkfs.ext4 /dev/sdf || true
      mount /dev/sdf /mnt/sshkeys
    fi
    chmod 700 /mnt/sshkeys

    cat > /mnt/sshkeys/id_rsa << 'KEY_EOF'
${tls_private_key.instance_key.private_key_pem}
KEY_EOF
    chmod 600 /mnt/sshkeys/id_rsa

    cat > /mnt/sshkeys/id_rsa.pub << 'KEYPUB_EOF'
${tls_private_key.instance_key.public_key_openssh}
KEYPUB_EOF
    chmod 644 /mnt/sshkeys/id_rsa.pub
EOF

  tags = {
    Name = var.instance_name
  }
}

resource "aws_ebs_volume" "key_volume" {
  availability_zone = aws_instance.app_server.availability_zone
  size              = 1
  type              = "gp3"
  tags = {
    Name = "${var.instance_name}-sshkey-volume"
  }
}

resource "aws_volume_attachment" "key_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.key_volume.id
  instance_id = aws_instance.app_server.id
  force_detach = true
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
