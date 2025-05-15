resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-subnet-${count.index + 1}"
    Project = var.project_tag
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-subnet-${count.index + 1}"
    Project = var.project_tag
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = var.vpc_id

  tags = {
    Name    = "internet-gateway"
    Project = var.project_tag
  }
}

data "aws_route_table" "route_table_main" {
  vpc_id = var.vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_route" "main_route_to_internet" {
  route_table_id         = data.aws_route_table.route_table_main.id
  destination_cidr_block = "0.0.0.0/0"                    
  gateway_id             = aws_internet_gateway.internet_gw.id 
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route.main_route_to_internet.route_table_id 
}

# If the containers you launch in private subnets do not need to access the internet, you can comment out the rest of this file in order to cut costs.

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet AZ1)
resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain = "vpc" 

  tags   = {
    Name    = "Nat Gateway AZ1 EIP"
    Project = var.project_tag
  }
}

# Allocate Elastic IP. (This EIP will be used for the Nat-Gateway in the Public Subnet AZ2)
resource "aws_eip" "eip_for_nat_gateway_az2" {
 domain = "vpc" 

  tags   = {
    Name    = "Nat Gateway AZ2 EIP"
    Project = var.project_tag
  }
}

# Create Nat Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.public[0].id

  tags   = {
    Name    = "Nat Gateway AZ1"
    Project = var.project_tag
  }

  depends_on = [aws_internet_gateway.internet_gw]
}

# Create Nat Gateway in Public Subnet AZ2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = aws_subnet.public[1].id

  tags   = {
    Name    = "Nat Gateway AZ2"
    Project = var.project_tag
  }

  depends_on = [aws_internet_gateway.internet_gw]
}

# Create Private Route Table AZ1 and add route through Nat Gateway AZ1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name    = "Private Route Table AZ1"
    Project = var.project_tag
  }
}

# Associate Private Subnet AZ1 with Private Route Table AZ1
resource "aws_route_table_association" "private_subnet_az1_route_table_az1_association" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private_route_table_az1.id

}

# Create Private Route Table AZ2 and add route through Nat Gateway AZ2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name    = "Private Route Table AZ2"
    Project = var.project_tag
  }
}

# Associate Private Subnet AZ2 with Private Route Table AZ2
resource "aws_route_table_association" "private_subnet_az2_route_table_az2_association" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private_route_table_az2.id
  
}