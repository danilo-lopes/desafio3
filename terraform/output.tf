output "wordpressDNS" {
  value = module.route53.wordpressDNS
}

output "wordpressPublicIP" {
  value = module.instance.wordpressPublicIP
}
