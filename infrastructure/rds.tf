resource "aws_db_instance" "db" {
  db_name           = "VioDB"
  identifier        = "viodb"
  username          = "postgres"
  password          = "postgres"
  apply_immediately = true
  engine            = "postgres"
  engine_version    = "15.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
}
