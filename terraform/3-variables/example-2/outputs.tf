output "my_public_ip" {
  description = "my_public_ip"
  value       = aws_instance.my_ec2_instance.public_ip
}

output "my_private_ip" {
  description = "my_privat_ip"
  value       = aws_instance.my_ec2_instance.private_ip
}
