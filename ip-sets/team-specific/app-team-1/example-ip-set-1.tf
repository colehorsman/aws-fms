# Example IP Set 1 - Managed by App Team 1
resource "aws_wafv2_ip_set" "example_ip_set_1" {
  name               = "example-ip-set-1"
  description        = "Example IP addresses for WAF rules (managed by App Team 1)"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["10.0.0.1/32", "10.0.0.2/32"]  # Example IP addresses

  tags = merge(
    var.tags,
    {
      Name = "example-ip-set-1"
    }
  )
} 