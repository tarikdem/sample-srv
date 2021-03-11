output "staging_rds_endpoint" {
  value = aws_db_instance.staging_db.endpoint
}

output "alb_url" {
  value = aws_alb.staging_alb.dns_name
}
