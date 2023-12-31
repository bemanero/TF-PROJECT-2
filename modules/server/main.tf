
resource "aws_instance" "server" {

  ami                    = var.ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_server]
  tags                   = var.tags


}