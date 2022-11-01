provider aws {
    profile = "default"
    region = "us-east-1"
    access_key = "AKIAZIINBKIYIYIAMZMI"
    secret_key = "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"
}

resource "aws_security_group" "ec2_webserver_security_group" {
  name        = "EC2-webserver-SG"
  description = "Webserver for EC2 Instances"
  
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
    instance_type = "t2.micro"
    ami           = "ami-0ee23bfc74a881de5"
    key_name      = "ubuntu"
    tags = {
      Name = "Apache_Webserver"
    }
    security_groups = ["${aws_security_group.ec2_webserver_security_group.name}"]
    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Welcome to ait</h1></body></html>" > /var/www/html/index.html
      EOF
}