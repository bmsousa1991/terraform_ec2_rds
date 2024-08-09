output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public_subnet_2.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "web_instance_id" {
  description = "ID of the web instance"
  value       = aws_instance.web.id
}

output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.wordpress.id
}
