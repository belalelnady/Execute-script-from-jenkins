module "vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "wep-app-vpc"
}


# subnets
module "public_subnet" {
  source      = "./subnet"
  vpc_id      = module.vpc.vpc_id
  cidr = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  subnet_name = "public-subnet"
  map_on_launch = true
}


module "internet_gateway" {
  source = "./internet_gateway"
  vpc_id = module.vpc.vpc_id
  name   = "internet_gateway"
}

# public routing table
module "public_routing_table" {
  source             = "./route_table"
  vpc_id             = module.vpc.vpc_id
  gateway_id         = module.internet_gateway.internet_gateway_id
  routing_table_name = "public-routing-table"
}



# public subnet 1 assossiation
module "assosiation" {
  source               = "./association"
  subnet_id            = module.public_subnet.subnet_id
  route_table_id       = module.public_routing_table.routing_table_id
}


# security group
module "security_groups" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}


#key pair
module "key_pair" {
  source   = "./key-pair"
  key_name = "web_app_key"
}

# instances
module "web-app-instances" {
  source                    = "./instances"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "web-app"
  public_subnet_id          = module.public_subnet.subnet_id
  public_sg_id              = module.security_groups.public_sg_id
  depends_on = [ module.internet_gateway ]
  key_name                  = module.key_pair.key_name
  user_data = ""

}

module "agent-instances" {
  source                    = "./instances"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "jenkins-agent"
  public_subnet_id          = module.public_subnet.subnet_id
  public_sg_id              = module.security_groups.public_sg_id
  depends_on = [ module.internet_gateway ]
  key_name                  = module.key_pair.key_name
  user_data =""
  #  <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt install -y python3-pip
  #             pip3 install ansible
  #             sudo apt install git-all
  #             sudo apt-get install openjdk-11-jdk -y
  #             curl -fsSL https://test.docker.com -o test-docker.sh
  #             sudo sh test-docker.sh
  #             curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
  #             sudo apt-get install -y nodejs
  #             EOF

}
module "jenkins_host" {
  source = "./instances"
  ami_id                    = "ami-0a0e5d9c7acc336f1" 
  instance_type             = "t2.micro"
  instance_name             = "jenkins-master"
  public_subnet_id          = module.public_subnet.subnet_id
  public_sg_id              = module.security_groups.public_sg_id
  depends_on = [ module.internet_gateway ]
  key_name                  = module.key_pair.key_name
   user_data = ""
  #<<-EOF
  #             #!/bin/bash
  #             sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  #             https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

  #             echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  #                 https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  #                 /etc/apt/sources.list.d/jenkins.list > /dev/null

  #             sudo apt-get update
  #             sudo apt install openjdk-17-jre-headless -y
  #             sudo apt-get install fontconfig openjdk-17-jre -y
  #             sudo apt-get install jenkins -y 
  #             EOF
}


# module "s3_bucket" {
#   source = "./s3-bucket"
#   bucket_name = "terraform-webapp-bucket-sstate"
# }

# module "dynamo_lock_state" {
#   source = "./dynamodb"
#   name = "terraform-lock-state"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"
#   tag_name = "terraform-lock-state"
# }

# terraform {
#   backend "s3" {
#     bucket         = "terraform-webapp-bucket-sstate"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock-state"
#     encrypt        = true
#   }
# }



  