/*
Create Security groups for the load balancer and the web servers. LB just takes inbound traffic and forwards to web servers. 
Web servers need egress 80/443 for communicating with the NAT GW so they can set themselves up with cloud-init scripts
*/

resource "aws_security_group" "LBSecGrp" {
  name          = "LB-SecGrp"
  description   = "Security group for the load balancer"
  vpc_id        = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    security_groups = ["${aws_security_group.WebSvrSecGrp.id}"]
  }
}

resource "aws_security_group" "WebSvrSecGrp" {
  name          = "WebSvr-SecGrp"
  description   = "Security group for the web servers"
  vpc_id        = "${aws_vpc.main.id}"
  
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}