resource "aws_instance" "database_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.database_subnet_a.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.database_profile.name

  depends_on = [
    aws_nat_gateway.nat_gateway
  ]

  user_data = <<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io awscli jq

                systemctl start docker
                systemctl enable docker

                MONGO_USERNAME=$(aws secretsmanager get-secret-value \
                    --secret-id ${data.aws_secretsmanager_secret.mongodb_credentials.name} \
                    --region ${var.aws_region} \
                    --query SecretString \
                    --output text | jq -r .MONGO_USERNAME)

                MONGO_PASSWORD=$(aws secretsmanager get-secret-value \
                    --secret-id ${data.aws_secretsmanager_secret.mongodb_credentials.name} \
                    --region ${var.aws_region} \
                    --query SecretString \
                    --output text | jq -r .MONGO_PASSWORD)

                docker volume create mongodb_data

                docker run -d \
                    --name mongodb \
                    --restart unless-stopped \
                    -p ${var.database_port}:${var.database_port} \
                    -v mongodb_data:/data/db \
                    -e MONGO_INITDB_ROOT_USERNAME=$MONGO_USERNAME \
                    -e MONGO_INITDB_ROOT_PASSWORD=$MONGO_PASSWORD \
                    mongo
                EOF

  tags = {
    Name = "${var.project_name}-Database-Instance"
  }
}

resource "aws_instance" "mongodb_replica" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.database_subnet_b.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.database_profile.name

  depends_on = [
    aws_instance.database_instance
  ]

  user_data = <<-EOF
                    #!/bin/bash

                    apt update -y
                    apt install -y docker.io jq

                    systemctl start docker
                    systemctl enable docker

                    # Start Mongo as replica node
                    docker volume create mongodb_data

                    docker run -d \
                    --name mongodb \
                    --restart unless-stopped \
                    -p 27017:27017 \
                    -v mongodb_data:/data/db \
                    mongo \
                    --replSet rs0 \
                    --bind_ip 0.0.0.0

                    sleep 30

                    PRIMARY_IP="${aws_instance.database_instance.private_ip}"
                    SECONDARY_IP=$(hostname -I | awk '{print $1}')

                    # Convert primary into replica set (if not already)
                    docker exec mongodb mongosh --host $PRIMARY_IP --eval '
                    try {
                        rs.status()
                    } catch(e) {
                        rs.initiate({
                        _id: "rs0",
                        members: [
                            { _id: 0, host: "'$PRIMARY_IP':27017" }
                        ]
                        })
                    }
                    '

                    sleep 15

                    # Add this instance as secondary
                    docker exec mongodb mongosh --host $PRIMARY_IP --eval "
                    rs.add('$SECONDARY_IP:27017')
                    "
                    EOF

  tags = {
    Name = "${var.project_name}-Mongo-Replica"
  }
}

resource "aws_dynamodb_table" "upload_events" {
  name         = "${var.project_name}-upload-events"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "songId"
  range_key = "uploadedAt"

  attribute {
    name = "songId"
    type = "S"
  }

  attribute {
    name = "uploadedAt"
    type = "S"
  }

  attribute {
    name = "mood"
    type = "S"
  }

  attribute {
    name = "genre"
    type = "S"
  }

  global_secondary_index {
    name            = "mood-uploadedAt-index"
    hash_key        = "mood"
    range_key       = "uploadedAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "genre-uploadedAt-index"
    hash_key        = "genre"
    range_key       = "uploadedAt"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "uploadedAt-index"
    hash_key        = "uploadedAt"
    projection_type = "ALL"
  }

  tags = {
    Name = "${var.project_name}-upload-events"
  }
}
