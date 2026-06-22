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

  tags = {
    Name = "${var.project_name}-Database-SG"
  }
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

resource "aws_security_group_rule" "mongodb_from_lambda" {
  description              = "MongoDB from Lambda"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
}

resource "aws_security_group_rule" "mongodb_from_eks_nodes" {
  description              = "MongoDB from EKS managed nodes"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "database_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
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

