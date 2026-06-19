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

  tags = {
    Name = "${var.project_name}-Frontend-ALB-SG"
  }
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

  tags = {
    Name = "${var.project_name}-Frontend-SG"
  }
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

  tags = {
    Name = "${var.project_name}-Backend-ALB-SG"
  }
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

  tags = {
    Name = "${var.project_name}-Backend-SG"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "${var.project_name}-Database-SG"
  description = "Security group for MongoDB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MongoDB from Backend Instances"
    from_port       = var.database_port
    to_port         = var.database_port
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  ingress {
    description = "MongoDB from Lambda"
    from_port   = var.database_port
    to_port     = var.database_port
    protocol    = "tcp"
    security_groups = [
      aws_security_group.lambda_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-Database-SG"
  }
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

  tags = {
    Name = "${var.project_name}-Lambda-SG"
  }
}

