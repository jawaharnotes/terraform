resource "aws_instance" "ubuntu" {
     ami = "ami-02d26659fd82cf299"
     instance_type = "t2.small"

     tags = {
        Name = "Ubuntu"
     }
}