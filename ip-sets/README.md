# IP Sets for FMS Policies

This directory contains IP sets that can be used in FMS policies. The IP sets are organized into two categories:

## Directory Structure

```
ip-sets/
├── central/              # Centrally managed IP sets
│   ├── main.tf           # Internal IP set
│   └── README.md         # Documentation for central IP sets
├── team-specific/        # Team-specific IP sets
│   ├── README.md         # Documentation for team-specific IP sets
│   └── risk/             # Risk team's IP sets
│       ├── mendix.tf     # Mendix IP set
│       ├── beacon.tf     # Beacon IP set
│       └── README.md     # Documentation for Risk team's IP sets
└── variables.tf          # Common variables for IP sets
```

## Centrally Managed IP Sets

These IP sets are managed by the security team and cannot be modified by application teams. Application teams can reference these IP sets in their FMS policies.

### Available IP Sets
- **Internal IP Set**: Contains internal IP addresses (8.8.8.8/32, 1.1.1.1/32)

## Team-Specific IP Sets

These IP sets are managed by individual application teams. Each team can maintain their own IP sets for their specific requirements.

### Available IP Sets
- **Mendix IP Set**: Managed by Risk team (2.2.2.2/32, 3.3.3.3/32)
- **Beacon IP Set**: Managed by Risk team (4.4.4.4/32, 5.5.5.5/32)

## How to Use

1. Reference the appropriate IP set in your FMS policy
2. Use the IP set in WAF rules to allow or block traffic from specific IP addresses
3. For centrally managed IP sets, use data sources to reference them
4. For team-specific IP sets, use the resource directly 