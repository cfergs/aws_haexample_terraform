output "website" {
  value = "http://${aws_lb.lb.dns_name}"
}