# Team-Specific IP Sets

This directory contains IP sets that are managed by individual application teams. Each team can maintain their own IP sets for their specific requirements.

## Directory Structure

```
team-specific/
├── risk/
│   ├── mendix.tf           # Mendix IP set managed by Risk team
│   └── beacon.tf           # Beacon IP set managed by Risk team
└── other-teams/            # Other teams can add their IP sets here
```

## How to Add a New IP Set

1. Create a new file in your team's directory
2. Define your IP set using the `aws_wafv2_ip_set` resource
3. Submit a pull request for review

## Example

```hcl
# Example of a team-specific IP set
resource "aws_wafv2_ip_set" "team_specific" {
  name               = "team-specific-ip-set"
  description        = "Team-specific IP addresses for WAF rules"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["10.0.0.0/24", "10.0.1.0/24"]

  tags = merge(
    var.tags,
    {
      Name = "team-specific-ip-set"
    }
  )
}
``` 