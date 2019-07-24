variable "zones" {
  default = [
    {
      name            = "zone1"
      #av_zone         = "${aws_availability_zones.available.names[0]}"
      public_subnet   = "10.200.0.0/24"
      private_subnet  = "10.200.2.0/23"
    },
    {
      name            = "zone2"
      #av_zone         = "${aws_availability_zones.available.names[1]}"
      public_subnet   = "10.200.1.0/24"
      private_subnet  = "10.200.4.0/23"
    },
  ]
}