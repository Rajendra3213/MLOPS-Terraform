output "database_name" {
  value = aws_glue_catalog_database.main.name
}

output "crawler_name" {
  value = aws_glue_crawler.main.name
}

output "etl_job_name" {
  value = aws_glue_job.etl.name
}
