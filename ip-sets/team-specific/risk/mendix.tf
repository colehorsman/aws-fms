# Mendix IP Set - Managed by Risk Team
resource "aws_wafv2_ip_set" "mendix" {
  name               = "mendix-ip-set"
  description        = "Mendix IP addresses for WAF rules (managed by Risk team)"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["2.2.2.2/32", "3.3.3.3/32"]

  tags = merge(
    var.tags,
    {
      Name = "mendix-ip-set"
    }
  )
} 