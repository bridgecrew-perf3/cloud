
output "server_public_ip" {
  value = aws_eip.one.public_ip
}

output "server_instance_id" {
  value = aws_instance.master_node.id
}
