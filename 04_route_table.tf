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
