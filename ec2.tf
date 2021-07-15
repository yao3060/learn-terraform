resource "aws_instance" "yyy-wordpress" {
  ami               = "ami-00e7797a8e3c1f7f6"
  instance_type     = "t2.micro"
  availability_zone = "cn-north-1a"
  key_name          = "yyy-wordpress"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.yyy-eni.id
  }

  user_data = <<-EOF
      #!/bin/bash
      sudo apt update -y
      sudo apt install apache2 -y
      sudo systemctl start apache2
      sudo bash -c 'echo Hello World > /var/www/html/index.html'
  EOF

  tags = {
    Name = var.instance_name
  }
}
