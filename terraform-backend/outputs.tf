output "backend_alb_dns_name" {
    description = "The DNS name for the backend ALB"
    value = aws_lb.backend_alb.dns_name
}

output "rds_endpoint" {
    description = "RDS MySQL endpoint"
    value = aws_rds_cluster.aurora_cluster.endpoint
}