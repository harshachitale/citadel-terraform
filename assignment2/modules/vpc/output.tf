output "vpc_id" {
    value = aws_vpc.cita2-vpc.id
}
output "public_subnet_id" {
    value = aws_subnet.cita-pub[*].id
  }
output "privatr_subnet_id" {
    value = aws_subnet.cita-private[*].id
}  
output "db_subnet_group" {
    value = aws_db_subnet_group.db_subnet_group.name
}
output "security_group_id" {
    value = aws_security_group.security_grp.id
}