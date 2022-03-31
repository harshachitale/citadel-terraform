resource "aws_instance" "cita2"{
      ami= "ami-0e472ba40eb589f49"
      instance_type = "t2.micro"
      key_name = aws_key_pair.citadel2.id
      tags = {
        "name" = "cita-assign2"
      }
}

resource "aws_key_pair" "citadel2" {
   public_key= file("/home/harsha/.ssh/web.pub")
}