terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-diego"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "mysql" {
  identifier_prefix = "terraform-up-and-running"
  instance_class = "db.t2.micro"
  engine = "mysql"
  allocated_storage = 10
  name = "mysql_database"
  username = "admin"
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage"
}