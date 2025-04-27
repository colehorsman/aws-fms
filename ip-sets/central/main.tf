# Internal IP Set - Centrally Managed
resource "aws_wafv2_ip_set" "internal" {
  name               = "internal-ip-set"
  description        = "Internal IP addresses for WAF rules (centrally managed)"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["8.8.8.8/32", "1.1.1.1/32"]

  tags = merge(
    var.tags,
    {
      Name = "internal-ip-set"
    }
  )
} 