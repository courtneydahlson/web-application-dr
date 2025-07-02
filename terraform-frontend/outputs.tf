output "frontend_alb_dns_name" {
    description = "The DNS name for the ALB"
    value = aws_lb.frontend_alb.dns_name
}
