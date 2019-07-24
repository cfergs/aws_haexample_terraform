provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_file = "./credentials"
  profile                 = "terraform"
}

/*
get a list of availability zones so you can restrict infrastructure to a single zone
Will be useful as we're creating 2 sets of VPC resources 
*/

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_security_group" "WebServerSG" {
  name          = "Web Server SG"
  description   = "Security group for the web servers"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ConfigServerSG" {
  name          = "Config Server SG"
  description   = "Security group for the web servers"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

}
