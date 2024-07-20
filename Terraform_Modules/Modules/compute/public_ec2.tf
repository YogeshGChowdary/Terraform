resource "aws_instance" "public-servers" {
  count = var.environment == "production" ? 3 : 1
  ami = lookup(var.amis, var.aws_region)
  instance_type = var.instance_type
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile
  subnet_id = element(var.private_subnets, count.index)
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.vpc_name}-private-server-${count.index + 1}"
    environment = "${var.environment}"
  }
  user_data = base64decode(file("userdata.sh"))
}

