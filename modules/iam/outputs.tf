output "sagemaker_execution_role_arn" {
  value = aws_iam_role.sagemaker_execution.arn
}

output "glue_role_arn" {
  value = aws_iam_role.glue.arn
}

output "stepfunctions_role_arn" {
  value = aws_iam_role.stepfunctions.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda.arn
}
