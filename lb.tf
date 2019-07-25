resource "aws_lb" "lb" {
  name      = "lb"
  internal  = false
  subnets   = "${aws_subnet.public_subnet.*.id}" #doco says to use [] but if you supply multiple then wont work!!. 
  security_groups = ["${aws_security_group.WebServerSG.id}"]
}

resource "aws_lb_target_group" "frontend" {
  name     = "lbtargetgrp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    enabled   = true
    interval  = 10
    healthy_threshold = 2
  }
}