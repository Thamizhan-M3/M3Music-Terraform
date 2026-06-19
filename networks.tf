resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-InternetGateway"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.bastionhost_subnet_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "${var.project_name}-NATGateway"
  }
}