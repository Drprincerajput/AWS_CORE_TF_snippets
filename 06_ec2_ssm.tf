provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0/16"
}


resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id

  }

}

resource "aws_route_table_association" "demo_route_table_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_route_table.id

}



resource "aws_security_group" "ssm_sg" {
  name        = "allow_ssm"
  description = "Allow SSM access"
  vpc_id = aws_vpc.demo_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EC2 SSM access
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "ec2_ssm" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.ssm_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "ssm-demo"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}


# resource "aws_instance" "public_ec2" {
#   ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public.id
#   vpc_security_group_ids      = [aws_security_group.ssh_sg.id]
#   associate_public_ip_address = true
#   key_name                    = "your-keypair-name" # Replace with your actual EC2 key pair name

#   tags = {
#     Name = "interview-basic-ec2"
#   }
# }