
variable "vpcID" {
  description = "VPC ID"
  default = "vpc-2699be5c"
}

variable "subnetID" {
  description = "Subnet ID"
  default = "subnet-f3e0f1dd"
}


variable "hostedDnsZoneID" {
  description = "biqueirabr route53 zone ID"
  default = "Z0961408LJOE4H2MBYPK"
}

variable "sshKeyName" {
  description = "SSH Key pair from EC2 Console"
  default = "ec2"
}


variable "instanceShape" {
  description = "Shape of Instance"
  default = "t2.micro"
}
