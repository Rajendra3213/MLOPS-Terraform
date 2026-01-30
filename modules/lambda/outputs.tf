output "evaluate_function_arn" {
  value = aws_lambda_function.evaluate.arn
}

output "data_validation_function_arn" {
  value = aws_lambda_function.data_validation.arn
}
