output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.bastionhost_subnet_a.id,
    aws_subnet.bastionhost_subnet_b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.frontend_subnet_a.id,
    aws_subnet.frontend_subnet_b.id,
    aws_subnet.backend_subnet_a.id,
    aws_subnet.backend_subnet_b.id,
    aws_subnet.database_subnet_a.id,
    aws_subnet.database_subnet_b.id
  ]
}

output "frontend_subnet_ids" {
  value = [
    aws_subnet.frontend_subnet_a.id,
    aws_subnet.frontend_subnet_b.id
  ]
}

output "backend_subnet_ids" {
  value = [
    aws_subnet.backend_subnet_a.id,
    aws_subnet.backend_subnet_b.id
  ]
}

output "database_subnet_ids" {
  value = [
    aws_subnet.database_subnet_a.id,
    aws_subnet.database_subnet_b.id
  ]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "database_sg_id" {
  value = aws_security_group.database_sg.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}

output "security_group_ids" {
  value = {
    frontend_alb = aws_security_group.frontend_alb_sg.id
    frontend     = aws_security_group.frontend_sg.id
    backend_alb  = aws_security_group.backend_alb_sg.id
    backend      = aws_security_group.backend_sg.id
    database     = aws_security_group.database_sg.id
    lambda       = aws_security_group.lambda_sg.id
  }
}
