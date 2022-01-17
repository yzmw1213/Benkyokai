# 最新版のAmazonLinux2のAMI情報
data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Elastic IP Adress for ec2
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2.id
  vpc = true
}

# Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name = "${var.ENVIRONMENT}_ec2"
  public_key = file("keys/${var.ENVIRONMENT}_ec2.pem.pub")
}

#  EC2 インスタンス
resource "aws_instance" "ec2" {
  ami = data.aws_ami.linux2.image_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id = aws_subnet.ec2_public_1a.id
  key_name = aws_key_pair.ec2_key.id

  user_data = <<-EOF
  #!/bin/bash
  yum update -y

  ### python
  sudo yum install python3 -y
  sudo yum install pip -y
  pip install flask
  python3 -m venv env
  source ~/env/bin/activate
  EOF
  tags = {
    Name = "${var.ENVIRONMENT}-ec2-server"
  }
}