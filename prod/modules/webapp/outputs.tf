/* AWS generated DNS name of the ELB 
*/
output "dns_name" {
  value = aws_elb.web.dns_name
}
