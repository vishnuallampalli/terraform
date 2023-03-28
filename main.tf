resource "aws_vpc" "vpc1" {
  
  cidr_block = var.vpc1
  tags = {
    "Name" = "vtfvpc"
  }
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = var.cidranges
    availability_zone = var.subnet1
    
  tags = {
    "Name" = "tfsubnet"
  }
}


resource "aws_internet_gateway" "tfig" {
    vpc_id = aws_vpc.vpc1.id

tags = {
  "Name" = "tf-ig"
}
  
}

resource "aws_security_group" "tfsg" {
   vpc_id = aws_vpc.vpc1.id 

   ingress {

    from_port = local.ssh_port
    to_port = local.ssh_port
    protocol = "tcp"
    cidr_blocks = local.anywhere2
   }

   ingress {
    from_port = local.http_port
    to_port = local.http_port
    protocol = "tcp"
    cidr_blocks =  local.anywhere2
   }


    tags = {
      "Name" = "tfsg1"
   }
  
}
resource "aws_route_table" "tf-rt" {
    vpc_id = aws_vpc.vpc1.id

  route {
    
    cidr_block = local.anywhere

    gateway_id = aws_internet_gateway.tfig.id

  } 
  tags = {
    "Name" = "tff-rtb"
  }
    
}

resource "aws_route_table_association" "tfrtass" {

  route_table_id = aws_route_table.tf-rt.id

  subnet_id = aws_subnet.sub1.id
  
}


