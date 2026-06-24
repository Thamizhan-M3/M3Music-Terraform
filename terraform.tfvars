aws_region = "ap-south-1"

availability_zone_a = "ap-south-1a"
availability_zone_b = "ap-south-1b"

project_name = "m3-music"

vpc_cidr = "10.0.0.0/16"

bastionhost_subnet_a_cidr = "10.0.1.0/24"
bastionhost_subnet_b_cidr = "10.0.2.0/24"
frontend_subnet_a_cidr    = "10.0.11.0/24"
frontend_subnet_b_cidr    = "10.0.12.0/24"
backend_subnet_a_cidr     = "10.0.21.0/24"
backend_subnet_b_cidr     = "10.0.22.0/24"
database_subnet_a_cidr    = "10.0.31.0/24"
database_subnet_b_cidr    = "10.0.32.0/24"

instance_type = "t2.micro"
ami_id        = "ami-07a00cf47dbbc844c"
key_name      = "M3"

frontend_port = 80
backend_port  = 5000
database_port = 27017

frontend_image = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/m3music-frontend:v4"
backend_image  = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/m3music-backend:v2"
frontend_url   = "http://m3music-dev.local"

desired_capacity = 3
min_size         = 3
max_size         = 4

songs_bucket_name = "m3-music"

admin_email = "mithelesh.tmz.m3@gmail.com"

upload_lambda_image = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/upload-processor:v9"
report_lambda_image = "115717304992.dkr.ecr.ap-south-1.amazonaws.com/report-processor:v1"
