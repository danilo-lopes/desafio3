resource "aws_instance" "wordpress" {
  ami = data.aws_ami.wordpress.id
  key_name = var.sshKeyName
  instance_type = var.instanceShape

  subnet_id = var.subnetID
  security_groups = [var.securitygroupID]

  tags = {
    Name = "wordpress"
  }

}

data "aws_ami" "wordpress" {
  owners = ["self"]

  filter {
    name = "state"
    values = ["available"]
  }
  filter {
    name = "tag:Name"
    values = ["wordpress-latest"]
  }
  most_recent = true
}
