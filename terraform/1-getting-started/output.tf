
output "public_ip_addr" {
  value = aws_instance.milua_server.public_ip
  
}

output "private_ip_addr" {
  value = aws_instance.milua_server.private_ip  
}
