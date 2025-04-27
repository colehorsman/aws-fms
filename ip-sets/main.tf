# Internal IP Set
resource "aws_wafv2_ip_set" "internal" {
  name               = "internal-ip-set"
  description        = "Internal IP addresses for WAF rules"
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

# Mendix IP Set
resource "aws_wafv2_ip_set" "mendix" {
  name               = "mendix-ip-set"
  description        = "Mendix IP addresses for WAF rules"
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