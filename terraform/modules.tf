module "instance" {
  source = "./modules/instance"

  subnetID = var.subnetID
  sshKeyName = var.sshKeyName
  instanceShape = var.instanceShape
  securitygroupID = module.securitygroup.seucuritygroupID
}

module "route53" {
  source = "./modules/route53"

  ec2PublicIP = module.instance.wordpressPublicIP
  hostedDnsZoneID = var.hostedDnsZoneID
}

module "securitygroup" {
  source = "./modules/securitygroup"

  vpcID = var.vpcID
}
