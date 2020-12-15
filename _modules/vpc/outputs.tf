# outputs
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "vpc id(s)"
}

output "subnet_public_id" {
  value       = tolist(values(aws_subnet.public))[*].id
  description = "list of aws public subnet ids"
}

output "subnet_private_id" {
  value       = tolist(values(aws_subnet.private))[*].id
  description = "list of aws private subnet ids"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "internet gateway id"
}

output "security_group_id" {
  value       = aws_security_group.main.id
  description = "vpc security group id(s)"
}

output "nat_gateway_public_ip" {
  value       = tolist(values(aws_nat_gateway.main))[*].public_ip
  description = "public ip of nat gateway service"
}

