# Beacon Team FMS Policy
resource "aws_fms_policy" "beacon_policy" {
  name                        = "FMS-Beacon-Team-Policy"
  description                 = "Beacon team's FMS policy"
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

  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  tags = merge(
    var.tags,
    {
      Name = "FMS-Beacon-Team-Policy"
    }
  )
}

# Policy Association
resource "aws_fms_policy_association" "beacon_policy_association" {
  policy_id = aws_fms_policy.beacon_policy.id
  target_id = var.organization_id
} 