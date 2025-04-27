# Custom Policy Template
# Copy this file to your team's directory and rename it to custom-policy.tf
# Modify the policy name, description, and rule groups as needed

# Example custom policy for specific resources
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
        },
        {
          ruleGroupId = {
            id = "AWSManagedRulesKnownBadInputsRuleSet"
          }
          priority = 2
        }
      ]
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
    })
  }

  # Specify the resource type this policy applies to
  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

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

# Enable WAF logging for the custom policy
resource "aws_wafv2_web_acl_logging_configuration" "custom_policy_logging" {
  log_destination_configs = [var.waf_log_destination_arn]
  resource_arn           = aws_fms_policy.team_custom_policy.arn
} 