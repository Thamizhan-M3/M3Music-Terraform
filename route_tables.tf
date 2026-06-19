resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-Public-RouteTable"
  }
}

resource "aws_route_table_association" "bastionhost_subnet_a_association" {
  subnet_id      = aws_subnet.bastionhost_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "bastionhost_subnet_b_association" {
  subnet_id      = aws_subnet.bastionhost_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-Private-RouteTable"
  }
}

resource "aws_route_table_association" "frontend_subnet_a_association" {
  subnet_id      = aws_subnet.frontend_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "frontend_subnet_b_association" {
  subnet_id      = aws_subnet.frontend_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "backend_subnet_a_association" {
  subnet_id      = aws_subnet.backend_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "backend_subnet_b_association" {
  subnet_id      = aws_subnet.backend_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_subnet_a_association" {
  subnet_id      = aws_subnet.database_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_subnet_b_association" {
  subnet_id      = aws_subnet.database_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}