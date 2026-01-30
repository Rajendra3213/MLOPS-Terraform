output "data_bucket_name" {
  value = aws_s3_bucket.data.id
}

output "model_bucket_name" {
  value = aws_s3_bucket.models.id
}

output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts.id
}

output "data_bucket_arn" {
  value = aws_s3_bucket.data.arn
}

output "model_bucket_arn" {
  value = aws_s3_bucket.models.arn
}
