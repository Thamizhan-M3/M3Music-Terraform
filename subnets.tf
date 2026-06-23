resource "aws_subnet" "bastionhost_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.bastionhost_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.project_name}-BastionHost-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
}

resource "aws_subnet" "bastionhost_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.bastionhost_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.project_name}-BastionHost-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
}

resource "aws_subnet" "frontend_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name                                            = "${var.project_name}-Frontend-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

resource "aws_subnet" "frontend_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name                                            = "${var.project_name}-Frontend-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

resource "aws_subnet" "backend_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name                                            = "${var.project_name}-Backend-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

resource "aws_subnet" "backend_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name                                            = "${var.project_name}-Backend-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

resource "aws_subnet" "database_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name                                            = "${var.project_name}-Database-Subnet-A"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  }
}

resource "aws_subnet" "database_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name                                            = "${var.project_name}-Database-Subnet-B"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  }
}
