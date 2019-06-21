output "database_host" {
  value = split(":", data.aws_db_instance.database.endpoint)[0]
}

output "database_name" {
  value = mysql_database.database.name
}

output "aws_ssm_parameter_database_username_arn" {
  value = aws_ssm_parameter.database_username.arn
}

output "aws_ssm_parameter_database_password_arn" {
  value = aws_ssm_parameter.database_password.arn
}

