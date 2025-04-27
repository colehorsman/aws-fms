# Risk Team IP Sets

This directory contains IP sets managed by the Risk team. These IP sets can be used in the Risk team's FMS policies.

## Available IP Sets

### Mendix IP Set
- **Name**: mendix-ip-set
- **Description**: Mendix IP addresses for WAF rules
- **IPs**: 2.2.2.2/32, 3.3.3.3/32
- **Usage**: Use this IP set to allow traffic from Mendix sources

### Beacon IP Set
- **Name**: beacon-ip-set
- **Description**: Beacon IP addresses for WAF rules
- **IPs**: 4.4.4.4/32, 5.5.5.5/32
- **Usage**: Use this IP set to allow traffic from Beacon sources

## How to Update

1. Edit the appropriate IP set file (mendix.tf or beacon.tf)
2. Update the IP addresses as needed
3. Submit a pull request for review

## How to Reference in FMS Policies

You can reference these IP sets in your FMS policies using the following format:

```hcl
# Example of referencing the Mendix IP set in a WAF rule
resource "aws_wafv2_web_acl_rule" "allow_mendix" {
  name        = "allow-mendix"
  description = "Allow traffic from Mendix IPs"
  priority    = 1
  action {
    allow {}
  }
  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.mendix.arn
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "allow-mendix"
    sampled_requests_enabled  = true
  }
}
``` 