resource "aws_vpc" "vpc" {
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"
  enable_dns_support = true
  enable_classiclink = false

  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

resource "aws_subnet" "ec2_public_1a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.ENVIRONMENT}-ec2-public-1a"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Part = "${var.ENVIRONMENT}-gw"
  }
}

# ルートテーブル
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.vpc.id

	tags = {
		Name = "${var.ENVIRONMENT}-public"
	}
}

# Route
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
}

# Association
resource "aws_route_table_association" "public_1a" {
	subnet_id      = aws_subnet.ec2_public_1a.id
	route_table_id = aws_route_table.public.id
}