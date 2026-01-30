resource "aws_glue_catalog_database" "main" {
  name = "${var.project_name}_${var.environment}_db"
}

resource "aws_glue_crawler" "main" {
  database_name = aws_glue_catalog_database.main.name
  name          = "${var.project_name}-${var.environment}-crawler"
  role          = var.role_arn

  s3_target {
    path = "s3://${var.data_bucket}/raw/"
  }

  tags = var.tags
}

resource "aws_glue_job" "etl" {
  name     = "${var.project_name}-${var.environment}-etl-job"
  role_arn = var.role_arn

  command {
    script_location = "s3://${var.data_bucket}/scripts/etl.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"        = "python"
    "--enable-metrics"      = "true"
    "--enable-spark-ui"     = "true"
    "--enable-job-insights" = "true"
  }

  glue_version      = "4.0"
  max_retries       = 1
  timeout           = 60
  number_of_workers = 2
  worker_type       = "G.1X"

  tags = var.tags
}

resource "aws_glue_workflow" "main" {
  name = "${var.project_name}-${var.environment}-workflow"

  tags = var.tags
}
