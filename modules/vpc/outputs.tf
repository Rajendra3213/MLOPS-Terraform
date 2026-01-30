output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "sagemaker_sg_id" {
  value = aws_security_group.sagemaker.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda.id
}
