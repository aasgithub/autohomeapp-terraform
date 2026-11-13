provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "aasnone"
}

resource "aws_instance" "terraform" {
  ami = "ami-0bcc094591f354be2"
  iam_instance_profile = "autohomeapp-EC2-S3"
  instance_type = "t2.micro"
  user_data = file("userdata.sh")
  key_name = aws_key_pair.my-key.key_name
  security_groups = [aws_security_group.terraform.name]
  tags = {
    Name = "Terraform"
  }
}

resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "terraform" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "terraform_public_dns" {
  value = aws_instance.terraform.public_dns
}