# Beacon IP Set - Managed by Risk Team
resource "aws_wafv2_ip_set" "beacon" {
  name               = "beacon-ip-set"
  description        = "Beacon IP addresses for WAF rules (managed by Risk team)"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["4.4.4.4/32", "5.5.5.5/32"]

  tags = merge(
    var.tags,
    {
      Name = "beacon-ip-set"
    }
  )
} 