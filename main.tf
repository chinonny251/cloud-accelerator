# ==========================================
# 0. GLOBALS, S3 BUCKET & CORE NETWORKING
# ==========================================

locals {
  env_name = "production-drills"
  common_tags = {
    Environment = local.env_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "variable_bucket" {
  bucket = var.bucket_name
  tags   = local.common_tags
}

# The VPC that was destroyed yesterday—bringing it back!
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "w5-vpc" })
}

# Public Subnet
resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "w5-public-subnet" })
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  tags              = merge(local.common_tags, { Name = "w5-private-subnet" })
}

# Internet Gateway so our Public Subnet can talk to the internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "w5-igw" })
}

# Route Table for Public Traffic
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(local.common_tags, { Name = "w5-public-rt" })
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# 1. SECURITY GROUPS (Our Firewalls)
# ==========================================

# Public Security Group (Bastion / Web Host)
resource "aws_security_group" "public_sg" {
  name        = "public-compute-sg"
  description = "Allow SSH from my IP and HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Secure SSH from home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip] #  Fixed syntax typo here
  }

  ingress {
    description = "HTTP access"
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

  tags = merge(local.common_tags, { Name = "public-sg" })
}

# Private Security Group (Backend / App Host)
resource "aws_security_group" "private_sg" {
  name        = "private-compute-sg"
  description = "Allow traffic ONLY from Public Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH only from Public SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "private-sg" })
}

# ==========================================
# 2. KEY PAIR
# ==========================================

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "week5-deployer-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${path.module}/week5-deployer-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}

# ==========================================
# 3. EC2 INSTANCE PROVISIONING
# ==========================================

# Public Instance (Bastion Host)
resource "aws_instance" "public_web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.deployer_key.key_name
  associate_public_ip_address = true

  tags = merge(local.common_tags, { Name = "w5-public-bastion" })
}

# Private Instance (App Server)
resource "aws_instance" "private_app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[0].id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  key_name                    = aws_key_pair.deployer_key.key_name
  associate_public_ip_address = false

  tags = merge(local.common_tags, { Name = "w5-private-app" })
}
