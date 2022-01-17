# EC2セキュリティグループ
resource "aws_security_group" "ec2" {
	vpc_id = aws_vpc.vpc.id
  name = "${var.ENVIRONMENT}-ec2-sg"

  tags = {
    Name = "sg_ec2"
  }
}

# EC2 ssh 接続許可
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.ec2.id
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  to_port = 22
  protocol = "tcp"
}

resource "aws_security_group_rule" "ec2_internet_connect" {
  security_group_id = aws_security_group.ec2.id
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
  protocol = "-1"
}

# EC2 HTTP 接続許可
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.ec2.id
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 5000
  to_port = 5000
  protocol = "tcp"
}