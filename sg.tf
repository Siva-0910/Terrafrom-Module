resource "aws_security_group" "main" {
  name = "${var.project}-${var.environment}-${vat.sg_name}"
  vpc_id = var.vpc_id
  description = var.sg_description

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/16" ]
}
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-${vat.sg_name}"
        }
    )
}