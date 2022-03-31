resource "aws_db_instance" "word-db" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "db"
  password             = "passwddb"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
