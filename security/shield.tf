resource "aws_shield_protection" "waf" {
  name         = "${var.name_prefix}-shield-protection"
  resource_arn = aws_wafv2_web_acl.main.arn

  tags = var.tags
}

resource "aws_shield_protection_group" "main" {
  protection_group_id = "${var.name_prefix}-protection-group"
  aggregation        = "MAX"
  pattern           = "ALL"

  members {
    resource_type = "CLOUDFRONT"
    account_id    = data.aws_caller_identity.current.account_id
  }

  members {
    resource_type = "APPLICATION_LOAD_BALANCER"
    account_id    = data.aws_caller_identity.current.account_id
  }

  tags = var.tags
}

# DDoS Response Team
resource "aws_shield_drt_access_role" "main" {
  role_arn = aws_iam_role.shield_drt.arn
  
  depends_on = [aws_shield_protection.waf]
}

resource "aws_iam_role" "shield_drt" {
  name = "${var.name_prefix}-shield-drt-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "drt.shield.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "shield_drt" {
  name = "${var.name_prefix}-shield-drt-policy"
  role = aws_iam_role.shield_drt.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "waf-regional:GetWebACL",
          "waf-regional:UpdateWebACL",
          "waf:GetWebACL",
          "waf:UpdateWebACL",
          "cloudfront:GetDistribution",
          "cloudfront:UpdateDistribution",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:UpdateLoadBalancerAttributes"
        ]
        Resource = "*"
      }
    ]
  })
} 