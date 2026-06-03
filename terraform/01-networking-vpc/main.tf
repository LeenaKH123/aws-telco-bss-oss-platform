resource "aws_vpc" "telco_vpc" {      #create AWS VPC, terraform name telco_vpc, aws resource vpc
  cidr_block           = var.vpc_cidr #assign 10.0.0.0/16 to VPC
  enable_dns_support   = true         #allows DNS resolution, website name becomes IP
  enable_dns_hostnames = true         #allows instances to receive DNS names

  tags = {                           #adds labels, useful for Billing, Search, Management
    Name = "${var.project_name}-vpc" #creates telco-bss-oss-vpc visible in AWS console
  }
}

resource "aws_subnet" "public_subnet" { #create subnet, room inside the VPC house
  vpc_id     = aws_vpc.telco_vpc.id     #attach subnet to VPC, terraform auto undertsands VPC first, subnet second--> dependency
  cidr_block = var.public_subnet_cidr   # assign 10.0.1.0/24 

  map_public_ip_on_launch = true                 #when ec2 launches auto get public ip, without it no internet access
  availability_zone       = "${var.aws_region}a" #physical aws data center

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" { #private network, future location for databases, order service, billing, no public ip
  vpc_id            = aws_vpc.telco_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" { # creates internet gateway, public subnet requires route to IGW, door to the internet, without it no internet access
  vpc_id = aws_vpc.telco_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public_rt" { #route table --> creates routing rules, GPS for packets
  vpc_id = aws_vpc.telco_vpc.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route" "public_internet_route" { #create route
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"                 #anydestination, anywhere, internet, whenever you see 0.0.0.0/0 think all IP addresses
  gateway_id             = aws_internet_gateway.igw.id #send traffic to internet gateway
}

resource "aws_route_table_association" "public_assoc" { #connects public subnet to public route table, without association route table exists but subnet does not use it.
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" { #secuity group = virtual firewall, security groups are stateful
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP and SSH access"
  vpc_id      = aws_vpc.telco_vpc.id

  ingress { # http rule, allow website traffic, web traffic uses TCP, anyone on the internet can connect
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"         # web traffic uses TCP
    cidr_blocks = ["0.0.0.0/0"] #anyone on the internet can connect
  }

  ingress {
    description = "Allow SSH - later restrict to your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}