terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "2.14.0"

  region = var.aws_region
}

provider "mysql" {
  version = "1.6.0"

  endpoint = data.aws_db_instance.database.endpoint
  username = data.aws_ssm_parameter.database_master_username.value
  password = data.aws_ssm_parameter.database_master_password.value

  tls = "skip-verify"
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.infrastructure_name
}

data "aws_ssm_parameter" "database_master_username" {
  name = "/${var.infrastructure_name}/database/master_username"
}

data "aws_ssm_parameter" "database_master_password" {
  name = "/${var.infrastructure_name}/database/master_password"
}

resource "mysql_database" "database" {
  name = var.name
}

resource "mysql_user" "user" {
  user               = var.name
  host               = "%"
  plaintext_password = var.user_password
  tls_option         = "SSL"
}

resource "mysql_grant" "vinodavita-com" {
  user     = var.name
  host     = mysql_user.user.host
  database = mysql_database.database.name
  privileges = [
    "ALL",
  ]
}

resource "aws_ssm_parameter" "database_username" {
  name = "/${var.infrastructure_name}/${var.name}/database/username"
  type = "String"

  value = var.name

  tags = {
    IsAntifragile = true
  }
}

resource "aws_ssm_parameter" "database_password" {
  name = "/${var.infrastructure_name}/${var.name}/database/password"
  type = "SecureString"

  value = var.user_password

  tags = {
    IsAntifragile = true
  }
}

