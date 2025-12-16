resource "aws_key_pair" "main" {
  key_name   = "harbour-space-devops-2025"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaU0oWOzx21O0hnMWJs6LT1Bt2c2G9jDLkvNI/3MmQJ laborant@flexbox (managed)"
}

resource "aws_instance" "main" {
  ami           = "ami-0006ba1ba3732dd33"
  instance_type = "t3.micro"
  key_name = aws_key_pair.main.id

  tags = {
    Name = "HelloWorld"
  }
}
