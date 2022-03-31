resource "aws_vpc" "cita2-vpc" {
      cidr_block =  "10.0.0.0/16"
      instance_tenancy = "default"
      tags= {
             Name = "cita2-vpc"
      } 
}

resource "aws_subnet" "cita-pub" {
      count = 3
      vpc_id = aws_vpc.cita2-vpc.id
      cidr_block = element(var.public_subnet, count.index)
      map_public_ip_on_launch = "true"
      availability_zone = element(var.availability_zone, count.index)
      tags = {
          Name = "public_subnet-${count.index}"
    } 
}
resource "aws_subnet" "cita-private" {
      count = 3
      vpc_id =  aws_vpc.cita2-vpc.id
      cidr_block = element(var.private_subnet, count.index) 
      availability_zone = element(var.availability_zone, count.index)
      tags = {
        "Name" = "private_subnet-${count.index}"
      }
}

resource "aws_internet_gateway" "cita-igw" {
      vpc_id = aws_vpc.cita2-vpc.id 
      tags = {
            Name = "cita-igw"
      }
}
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.cita-igw]
}
resource "aws_nat_gateway" "cita-ngw" {
      allocation_id = aws_eip.nat_eip.id
      subnet_id = element(aws_subnet.cita-private.*.id, 0)
      tags = {
        "Name" = "cita-ngw"
      }
      depends_on = [
        aws_internet_gateway.cita-igw
      ]
      }


resource "aws_route_table" "cita-private-rt" {
      vpc_id = aws_vpc.cita2-vpc.id
      route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.cita-ngw.id
      }
      tags = {
            Name = "cita-private-rt"
      }
  
}            
resource "aws_route_table" "cita-public-rt" {
      vpc_id = aws_vpc.cita2-vpc.id
      route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.cita-igw.id
      }

      tags = {
            Name = "cita-public-rt"
      }
  
}

resource "aws_route_table_association" "public-route-sub" {
      count = 3
      subnet_id = element(aws_subnet.cita-pub.*.id,count.index) 
      route_table_id = aws_route_table.cita-public-rt.id 
  }
resource "aws_route_table_association" "private-route-sub" {
      count = 3
      subnet_id = element(aws_subnet.cita-private.*.id,count.index)
      route_table_id = aws_route_table.cita-private-rt.id
  
}
resource "aws_db_subnet_group" "db_subnet_group" { 
      name = "db_subnet_grp"
      subnet_ids = aws_subnet.cita-private.*.id 
}
resource "aws_security_group" "security_grp" {
      name = "security-grp"
      vpc_id = aws_vpc.cita2-vpc.id
      
      ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "http"
        from_port = 80
        protocol = "tcp"
        to_port = 80
      }
      ingress {
        cidr_blocks= ["0.0.0.0/0"]
        description = "https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
      }

      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh"
        from_port = 22
        to_port =22
        protocol = "tcp" 
      }

      ingress {
         cidr_blocks = ["0.0.0.0/0"]
         description = "rds"
         from_port = 5432
         to_port = 5432
         protocol = "tcp"   
      }     
      egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 0
        protocol = "-1"
        to_port = 0
      } 
}
