#Get latest ECS image, as per: https://letslearndevops.com/2018/08/23/terraform-get-latest-centos-ami/
data "aws_ami" "latest_ecs" {
most_recent = true
owners = ["591542846629"] # AWS

  filter {
      name   = "name"
      values = ["*amazon-ecs-optimized"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }  
}

resource "aws_launch_configuration" "ami_config" {
    name_prefix     = "web"
    image_id        = "${data.aws_ami.latest_ecs.id}"
    instance_type   = "t2.micro"
    security_groups = ["${aws_security_group.WebServerSG.id}"]
    
    user_data = <<EOF
      #!/bin/bash
      sudo yum -y update
      sudo yum -y install httpd php
      sudo chkconfig httpd on
      wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-100-ARCHIT/v5.5.6/lab-2-ha/scripts/phpapp.zip
      sudo unzip phpapp.zip -d /var/www/html/
      sudo service httpd start
    EOF
}

resource "aws_autoscaling_group" "scale_grp" {
  name                 = "Web App"
  launch_configuration = "${aws_launch_configuration.ami_config.name}"
  min_size             = 2
  max_size             = 8
  vpc_zone_identifier  = "${aws_subnet.private_subnet.*.id}"
}