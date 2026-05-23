resource "aws_instance" "web" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  disable_api_termination = true

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  lifecycle {
    # This host contains the deployed Docker stacks and their local data.
    # Require an explicit configuration change before Terraform can replace it.
    prevent_destroy = true
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/scripts/bootstrap.sh")

  tags = {
    Name = var.instance_name
  }
}
