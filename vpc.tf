resource "aws_vpc" "roboshop" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"

tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}-vpc"
})
}
resource "aws_internet_gateway" "roboshop"{
    vpc_id = aws_vpc.roboshop.id
    tags = merge(local.common_tags,{
        Name = "${var.project}-${var.environment}"
    })
}  

resource "aws_subnet" "public" {
    count = length(var.public_cidr)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.public_cidr[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names, 0, 2)[count.index]
    map_public_ip_on_launch = "true"
tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_subnet" "private" {
    count = length(var.private_cidr)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.private_cidr[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names, 0, 2)[count.index]
tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_subnet" "database" {
    count = length(var.database_cidr)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.database_cidr[count.index]
    availability_zone = slice(data.aws_availability_zones.available.names, 0, 2)[count.index]
tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_eip" "nat" {
    domain = "vpc"
  tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_nat_gateway" "roboshop" {
    subnet_id = aws_subnet.public[0].id
    allocation_id = "aws_eip.nat"
    tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
    depends_on = [ aws_internet_gateway.roboshop ]
}
resource "aws_route_table" "pubilc" {
    vpc_id = aws_vpc.roboshop.id
    tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.roboshop.id
    tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
    })
}
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.roboshop.id
    tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}"
})
}
resource "aws_route" "public" {
    route_table_id = aws_route_table.pubilc.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.roboshop.id
  }
resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
resource "aws_route" "database" {
    route_table_id = aws_route_table.pubilc.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
  resource "aws_route_table_association" "public" {
    count = length(var.public_cidr)
    route_table_id = aws_route.public.id
    subnet_id = aws_subnet.public[count.index].id
  }
  resource "aws_route_table_association" "private" {
    count = length(var.private_cidr)
    route_table_id = aws_route.private.id
    subnet_id = aws_subnet.private[count.index].id
  }
 resource "aws_route_table_association" "database" {
    count = length(var.database_cidr)
    route_table_id = aws_route.database.id
    subnet_id = aws_subnet.database[count.index].id
  }

###############################################################################
# resource "aws_vpc" "main"{
#     cidr_block = var.cidr_block
#     instance_tenancy = "default"
#     enable_dns_hostnames = "true"
# }

# resource "aws_internet_gateway" "main" {
#     vpc_id = "aws_vpc.main.id"
# }

# resource "aws_subnet" "public" {
#     count = length(var.public_cidr_block)
#     vpc_id = "aws_vpc.main"
#     cidr_block = var.public_cidr_block[count.index]
#     availability_zone = slice(data.aws_availability_zones.available.names, 0,2)[count.index]
# }
# resource "aws_subnet" "private" {
#     count = length(var.private_cidr_block)
#     vpc_id = "aws_vpc.main"
#     cidr_block = var.private_cidr_block[count.index]
#     availability_zone = slice(data.aws_availability_zones.available.names, 0,2)[count.index]
# }
# resource "aws_subnet" "database" {
#     count = length(var.database_cidr_block)
#     vpc_id = "aws_vpc.main"
#     cidr_block = var.database_cidr_block[count.index]
#     availability_zone = slice(data.aws_availability_zones.available.names, 0,2)[count.index]
# }
# resource "aws_eip" "nat" {
#     domain = "vpc"
# }
# resource "aws_nat_gateway" "main" {
#     allocation_id = aws_eip.nat.id
#     subnet_id = aws_subnet.public[0].id
#     depends_on = [ aws_internet_gateway.main ]
# }



