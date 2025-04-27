# App Teams WAF Policies

This directory contains WAF policies for different app teams, with AWS account scoping for each team.

## Team Account Scoping

### Risk Team
- Development: 333333333333
- QA: 444444444444
- Production: 555555555555

### Beacon Team
- Development: 666666666666
- Production: 777777777777

### Life Team
- Development: 111111111111
- Production: 222222222222

### EDH Team
- Development: 888888888888
- Production: 999999999999

## Policy Structure

Each team has a default policy that includes:

1. **Account Scoping**: WAF rules are applied only to the specified AWS accounts
2. **Resource Tagging**: Resources are tagged with team-specific tags
3. **Rule Groups**: Default rule groups with appropriate priorities
4. **WAF Logging**: All requests are logged for monitoring and analysis

## Default Rule Groups

All teams have the following default rule groups:

1. **InternalIPSet** (Priority: 1)
   - Blocks requests from non-internal IPs
   - Override action: BLOCK

2. **AWSManagedRulesCommonRuleSet** (Priority: 2)
   - Common web application vulnerabilities
   - Default action: BLOCK

3. **AWSManagedRulesKnownBadInputsRuleSet** (Priority: 3)
   - Known bad inputs and attack patterns
   - Default action: BLOCK

4. **AWSManagedRulesAmazonIpReputationList** (Priority: 4)
   - IP reputation list
   - Default action: BLOCK

## Custom Rules

Teams can create custom rules by adding new policy files in their team directory. These rules will be applied in addition to the default policy.

## Best Practices

1. **Account Management**
   - Keep account IDs up to date
   - Review account scoping regularly
   - Ensure proper tagging of resources

2. **Rule Management**
   - Review rule priorities periodically
   - Monitor rule effectiveness
   - Update rules based on security requirements

3. **Logging and Monitoring**
   - Review WAF logs regularly
   - Set up appropriate alerts
   - Monitor for false positives

4. **Security**
   - Regularly review and update security policies
   - Test rules in development before production
   - Document any custom rules or exceptions

## Directory Structure

```
app-teams/
├── team-name/
│   ├── README.md           # Team-specific documentation
│   ├── default-policy.tf   # Default policy (managed by security team only)
│   ├── custom-policy.tf    # Team-specific custom policies
│   └── variables.tf        # Team-specific variables
```

## Submission Guidelines

1. Create a new directory with your team name
2. Include a README.md with:
   - Team name and contact information
   - Description of the FMS configurations
   - Any special requirements or considerations
3. For custom policies:
   - Create a new file (e.g., `custom-policy.tf`)
   - Use tags to target specific resources
   - Submit your changes via pull request
4. Ensure your configurations follow the organization's security standards

## Example Custom Policy

```hcl
# Example team-specific custom policy
resource "aws_fms_policy" "team_custom_policy" {
  name                        = "FMS-TeamName-Custom-Policy"
  description                 = "Team-specific custom FMS policy"
  exclude_resource_tags       = var.exclude_resource_tags
  remediation_enabled         = true
  delete_unused_fm_resources = true

  security_service_policy_data {
    type = "WAF"
    managed_service_data = jsonencode({
      type = "WAF"
      preProcessRuleGroups = [
        {
          ruleGroupId = {
            id = "AWSManagedRulesCommonRuleSet"
          }
          priority = 1
        }
      ]
      defaultAction = {
        type = "BLOCK"
      }
    })
  }

  resource_type = "AWS::YourResourceType"

  tags = merge(
    var.tags,
    {
      Name = "FMS-TeamName-Custom-Policy"
    }
  )
}

# Policy Association with tag-based targeting
resource "aws_fms_policy_association" "team_custom_policy_association" {
  policy_id = aws_fms_policy.team_custom_policy.id
  target_id = var.organization_id
}
```

## Important Notes

1. **Default Policies**: Do not modify the `default-policy.tf` file. It is managed by the security team only.
2. **Custom Policies**: Create new files for your custom policies.
3. **Tagging**: Use tags to target specific resources for your custom policies.
4. **Security Standards**: All policies must comply with the organization's security standards. 