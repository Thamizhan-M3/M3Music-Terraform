resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-VPC"
  })
}

resource "aws_subnet" "bastionhost_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.bastionhost_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-BastionHost-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  })
}

resource "aws_subnet" "bastionhost_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.bastionhost_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-BastionHost-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  })
}

resource "aws_subnet" "frontend_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Frontend-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  })
}

resource "aws_subnet" "frontend_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Frontend-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  })
}

resource "aws_subnet" "backend_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Backend-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  })
}

resource "aws_subnet" "backend_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Backend-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  })
}

resource "aws_subnet" "database_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Database-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  })
}

resource "aws_subnet" "database_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-Database-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-InternetGateway"
  })
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-NAT-EIP"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.bastionhost_subnet_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-NATGateway"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Public-RouteTable"
  })
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

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Private-RouteTable"
  })
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

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_route_table.id
  ]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-s3-vpc-endpoint"
  })
}

resource "aws_security_group" "frontend_alb_sg" {
  name        = "${var.project_name}-Frontend-ALB-SG"
  description = "Security group for Frontend ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Frontend-ALB-SG"
  })
}

resource "aws_security_group" "frontend_sg" {
  name        = "${var.project_name}-Frontend-SG"
  description = "Security group for Frontend Instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Frontend ALB"
    from_port       = var.frontend_port
    to_port         = var.frontend_port
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Frontend-SG"
  })
}

resource "aws_security_group" "backend_alb_sg" {
  name        = "${var.project_name}-Backend-ALB-SG"
  description = "Security group for Internal Backend ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Frontend Instances"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Backend-ALB-SG"
  })
}

resource "aws_security_group" "backend_sg" {
  name        = "${var.project_name}-Backend-SG"
  description = "Security group for Backend Instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Backend ALB"
    from_port       = var.backend_port
    to_port         = var.backend_port
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Backend-SG"
  })
}

resource "aws_security_group" "database_sg" {
  name        = "${var.project_name}-Database-SG"
  description = "Security group for MongoDB"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Database-SG"
  })
}

resource "aws_security_group_rule" "mongodb_from_backend" {
  description              = "MongoDB from Backend Instances"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.backend_sg.id
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.project_name}-Lambda-SG"
  description = "Lambda security group"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-Lambda-SG"
  })
}

resource "aws_security_group_rule" "mongodb_from_lambda" {
  description              = "MongoDB from Lambda"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
}

resource "aws_security_group_rule" "database_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
