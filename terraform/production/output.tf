output "production_rds_endpoint" {
  value = aws_db_instance.production_db.endpoint
}

output "alb_url" {
  value = aws_alb.production_alb.dns_name
}
