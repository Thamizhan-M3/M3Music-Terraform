resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = "${var.project_name}-Frontend-LT"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.frontend_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io nginx awscli

                systemctl start docker
                systemctl enable docker

                systemctl start nginx
                systemctl enable nginx

                aws ecr get-login-password --region ${var.aws_region} | \
                docker login \
                    --username AWS \
                    --password-stdin \
                    115717304992.dkr.ecr.ap-south-1.amazonaws.com

                docker pull ${var.frontend_image}

                docker run -d \
                    --name frontend \
                    --restart unless-stopped \
                    --log-driver=awslogs \
                    --log-opt awslogs-region=${var.aws_region} \
                    --log-opt awslogs-group=/${var.project_name}/frontend \
                    --log-opt awslogs-stream=frontend \
                    -p 3000:${var.frontend_port} \
                    -e VITE_API_URL="/api" \
                    ${var.frontend_image}

                cat > /etc/nginx/sites-available/default <<'NGINXCONF'
                server {
                    listen 80;

                    client_max_body_size 100M;

                    location / {
                        proxy_pass http://localhost:3000;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/ {
                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }
                }
                NGINXCONF

                nginx -t

                systemctl restart nginx
                EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-Frontend-Instance"
    }
  }
}

resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = "${var.project_name}-Backend1-LT"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.backend_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.backend_sg.id
  ]

  user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io awscli jq

                systemctl start docker
                systemctl enable docker
                JWT_SECRET=$(aws secretsmanager get-secret-value \
                    --secret-id ${data.aws_secretsmanager_secret.jwt_secret.name} \
                    --region ${var.aws_region} \
                    --query SecretString \
                    --output text | jq -r .JWT_SECRET)

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

                aws ecr get-login-password --region ${var.aws_region} | \
                docker login \
                    --username AWS \
                    --password-stdin \
                    115717304992.dkr.ecr.ap-south-1.amazonaws.com

                docker pull ${var.backend_image}

                docker run -d \
                    --name backend \
                    --restart unless-stopped \
                    --log-driver=awslogs \
                    --log-opt awslogs-region=${var.aws_region} \
                    --log-opt awslogs-group=/${var.project_name}/backend \
                    --log-opt awslogs-stream=backend \
                    -e PORT=${var.backend_port} \
                    -e MONGODB_URI=mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@${aws_instance.database_instance.private_ip}:${var.database_port}/m3-music?authSource=admin \
                    -e JWT_SECRET=$JWT_SECRET \
                    -e AWS_REGION=${var.aws_region} \
                    -e S3_BUCKET_NAME=${var.songs_bucket_name} \
                    -e S3_PUBLIC_URL=https://${aws_cloudfront_distribution.songs_cdn.domain_name} \
                    -p ${var.backend_port}:${var.backend_port} \
                    ${var.backend_image}
                EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-Backend1-Instance"
    }
  }
}