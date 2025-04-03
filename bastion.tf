# Optional configuration: Bastion host for SSH access

resource "aws_key_pair" "bastion" {
  key_name   = "${var.project_name}-bastion-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = aws_key_pair.bastion.key_name

  root_block_device {
    volume_size = 10
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }
}
