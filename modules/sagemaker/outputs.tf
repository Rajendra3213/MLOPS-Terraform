output "domain_id" {
  value = aws_sagemaker_domain.main.id
}

output "domain_arn" {
  value = aws_sagemaker_domain.main.arn
}

output "user_profile_arn" {
  value = aws_sagemaker_user_profile.main.arn
}

output "model_package_group_name" {
  value = aws_sagemaker_model_package_group.main.model_package_group_name
}
