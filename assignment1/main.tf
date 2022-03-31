resource "aws_vpc" "test-vpc" {
      cidr_block =  "10.0.0.0/16"
      instance_tenancy = "default"
      tags= {
             Name = "test-vpc"
      } 
}

resource "aws_subnet" "test-pub" {
      vpc_id = aws_vpc.test-vpc.id
      cidr_block =  "10.0.1.0/24"
      map_public_ip_on_launch = "true"
      tags = {
          Name = "public subnet"
    }
}

resource "aws_internet_gateway" "test-igw" {
      vpc_id = aws_vpc.test-vpc.id 
      tags = {
            Name = "test-igw"
      }
}
resource "aws_route_table" "test-public-rt" {
      vpc_id = aws_vpc.test-vpc.id
      route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.test-igw.id
      }
      tags = {
            Name = "test-public-rt"
      }
  
}

resource "aws_route_table_association" "public-route-sub" {
      subnet_id = aws_subnet.test-pub.id 
      route_table_id = aws_route_table.test-public-rt.id 
  }


resource "aws_instance" "word"{
      ami= "ami-0e472ba40eb589f49"
      instance_type = "t2.micro"
      subnet_id = aws_subnet.test-pub.id
      user_data = file("./word.sh")
      key_name = aws_key_pair.web.id
      vpc_security_group_ids = [aws_security_group.access.id]
}

resource "aws_key_pair" "web" {
   public_key= file("/home/harsha/.ssh/web.pub")

}
resource "aws_security_group" "access" {
      vpc_id = aws_vpc.test-vpc.id 
      name = "access"
      ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
            from_port        = 443
            to_port          = 443
            protocol         = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
  }
      egress {
            from_port        = 0
            to_port          = 0
            protocol         = "-1"
            cidr_blocks = ["0.0.0.0/0"]
      }
}

resource "aws_db_instance" "word-db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "wordb"
  password             = "wordmydb"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}