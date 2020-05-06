provider "aws" {
  profile = "default"
  region   = "eu-west-3"
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = "tf-prod-20200505"
  acl    = "private"
}


/* Default vpc
as our code will use networking and compute features we define a vpc*/
resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "prod_web" {
  name        = "tf-prod-web"
  description = "Allows standard http and https ports inbound and everything outbound. This is for example purpose. In real case scenarii restrictions would be applied"
 
  ingress{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // for example purpose we allow everything in 
  }
  ingress{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // for example purpose we allow everything in 
  }

  // for example purpose allow all ports, all protocol, and all ip addresses
  egress{
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      "Terraform" = "true"
  }
}

/*
instance with NGINX Open Source Certified by Bitnami subscription
*/
resource "aws_instance" "prod_web" {
  count = 2

  ami = "ami-0a0f02941b5882dd8"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" = "true"
  }
}

/*
Decoupling the creation of the IP and it's assigment
Scaling : 
syntax accepted  aws_instance.prod_web[0].id
or aws_instance.prod_web.0.id
 
*/
resource "aws_eip_association" "prod_web" {
  instance_id   = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id 
}

  

/*EIP*/
resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" = "true"
  }
}
