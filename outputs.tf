output "ec2-t2_key_pair" {
  value     = tls_private_key.t2_private_key.private_key_openssh
  sensitive = true
}