provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "main" {
  key_name   = "key-for-lab-laborant-01" 
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtWOuiGt6NIkw5g34iDMg63umd9sgUXamI0OpZLZPUx laborant@flexbox (managed)"
}

resource "aws_security_group" "main" {
  name        = "allow-ssh-and-4444-laborant"
  description = "Allow SSH and port 4444"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4444
    to_port     = 4444
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

resource "aws_instance" "main" {
  ami           = "ami-0006ba1ba3732dd33" # Ubuntu 20.04 (eu-central-1)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.main.key_name
  
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "My-AWS-Server"
  }
}
