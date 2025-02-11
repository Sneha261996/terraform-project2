resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "my_ec2" {
  ami             = "ami-04b4f1a9cf54c11d0" # Replace with a valid AMI
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name = "GitHubActionsEC2"
  }
}

output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
