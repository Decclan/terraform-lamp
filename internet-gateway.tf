#create internet gateway
resource "aws_internet_gateway" "myvpc_internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myvpc_internet_gateway"
  }
}
