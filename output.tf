output "vpc_id" {
    value = aws_vpc.main.id
}
# output "zone_availability"{
#     value = data.aws_availability_zones.available
# }