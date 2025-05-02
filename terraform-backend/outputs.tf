output "backend_alb_dns_name" {
    description = "The DNS name for the backend ALB"
    value = aws_lb.backend_alb.dns_name
}

output "rds_endpoint" {
    description = "RDS MySQL endpoint"
    value = aws_db_instance.backend_db_rds.endpoint
}