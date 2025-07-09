resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.10/24"
  availability_zone = "us-east-1a"
}