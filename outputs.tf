output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "sagemaker_domain_id" {
  description = "SageMaker Domain ID"
  value       = module.sagemaker.domain_id
}

output "data_bucket_name" {
  description = "S3 Data Bucket Name"
  value       = module.s3.data_bucket_name
}

output "model_bucket_name" {
  description = "S3 Model Bucket Name"
  value       = module.s3.model_bucket_name
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.repository_url
}
