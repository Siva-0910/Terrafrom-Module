variable "cidr_block" {
    default = "10.0.0.0/16"
}
variable "public_cidr" {
    type = list(string)
}
variable "private_cidr" {
    type = list(string)
}
variable "database_cidr" {
    type = list(string)
}
variable "project" {
    default = {}
}
variable "environment" {
    default = {}
}
variable "sg_name" {
    default = {}
}
# variable "vpc_id" {
#     type = "string"
# }
variable "sg_description" {

}