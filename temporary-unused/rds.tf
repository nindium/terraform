resource "aws_db_instance" "cloudiar-tf" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  name                      = "my_dbase"
  username                  = "cloudiar"
  password                  = "cloudiar"
  parameter_group_name      = "default.mysql5.7"
  db_subnet_group_name      = aws_db_subnet_group.privat_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "cloudiar-tf-snapshoot"
}

resource "aws_db_subnet_group" "privat_subnet_group" {
  name       = "privat"
  subnet_ids = aws_subnet.private_subnet[*].id

  tags = {
    Name = "Cloudiar RDS subnet group"
  }
}
