#create EC2 instance
resource "aws_instance" "my_web_instance" {
  ami                    = lookup(var.images, var.region)
  instance_type          = "t2.micro"
  key_name               = "MyKeyPair"
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
  subnet_id              = aws_subnet.myvpc_public_subnet.id
  tags = {
    Name = "my_web_instance"
  }
  volume_tags = {
    Name = "my_web_instance_volume"
  }
  provisioner "remote-exec" { #install apache, mysql client, php
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo yum install -y mysql php php-mysql"
    ]
  }
  provisioner "file" { #copy the index file form local to remote
    source      = "index.php"
    destination = "/var/www/html/index.php"
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    host     = self.public_ip

    private_key = file("/home/decclan/Development/terraform-lamp/MyKeyPair.pem")
  }
}
