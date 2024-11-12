# Add output variables
output "instance_ids" {
  value = aws_instance.instances[*].id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}
