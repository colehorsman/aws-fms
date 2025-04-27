# Centrally Managed IP Sets

This directory contains IP sets that are centrally managed by the security team. These IP sets cannot be modified by application teams but can be referenced in their FMS policies.

## Available IP Sets

### Internal IP Set
- **Name**: internal-ip-set
- **Description**: Internal IP addresses for WAF rules
- **IPs**: 8.8.8.8/32, 1.1.1.1/32
- **Usage**: Use this IP set to allow traffic from internal sources

## How to Reference

Application teams can reference these IP sets in their FMS policies using the following format:

```hcl
# Example of referencing the internal IP set in a WAF rule
resource "aws_wafv2_web_acl_rule" "allow_internal" {
  name        = "allow-internal"
  description = "Allow traffic from internal IPs"
  priority    = 1
  action {
    allow {}
  }
  statement {
    ip_set_reference_statement {
      arn = data.aws_wafv2_ip_set.internal.arn
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "allow-internal"
    sampled_requests_enabled  = true
  }
}

# Data source to reference the internal IP set
data "aws_wafv2_ip_set" "internal" {
  name        = "internal-ip-set"
  description = "Internal IP addresses for WAF rules (centrally managed)"
  scope       = "REGIONAL"
}
``` 