output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]
  description = "List of private subnet IDs"
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_zone1.id,
    aws_subnet.public_zone2.id
  ]
  description = "List of public subnet IDs"
}
