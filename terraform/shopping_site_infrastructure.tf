# Define variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Create VPC and subnets
resource "aws_vpc" "shopping_site_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "shopping_site_subnet1" {
  vpc_id     = aws_vpc.shopping_site_vpc.id
  cidr_block = var.subnet_cidr_blocks[0]
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "shopping_site_subnet2" {
  vpc_id     = aws_vpc.shopping_site_vpc.id
  cidr_block = var.subnet_cidr_blocks[1]
  availability_zone = "${var.aws_region}b"
}

# Create security groups
resource "aws_security_group" "shopping_site_sg" {
  name        = "shopping-site-sg"
  description = "Security group for the shopping site"

  vpc_id = aws_vpc.shopping_site_vpc.id

  # Define inbound and outbound rules as per your requirements
  ingress {
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
}

# Create EC2 instances
resource "aws_instance" "shopping_site_instance1" {
  ami           = "ami-xxxxxxxx"  # Replace with the desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.shopping_site_subnet1.id
  vpc_security_group_ids = [aws_security_group.shopping_site_sg.id]
  key_name      = "your-key-pair-name"  # Replace with your key pair name

  # Add additional configuration for the instance (e.g., user data, provisioners, etc.)
}

resource "aws_instance" "shopping_site_instance2" {
  ami           = "ami-xxxxxxxx"  # Replace with the desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.shopping_site_subnet2.id
  vpc_security_group_ids = [aws_security_group.shopping_site_sg.id]
  key_name      = "your-key-pair-name"  # Replace with your key pair name

  # Add additional configuration for the instance (e.g., user data, provisioners, etc.)
}

# Add additional resources as per your shopping site requirements (e.g., load balancers, databases, etc.)
