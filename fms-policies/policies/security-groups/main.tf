# Security Group Policy for FMS
resource "aws_fms_policy" "security_group_policy" {
  name                  = "fms-security-group-policy"
  description           = "FMS policy for managing security groups across accounts"
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = true
  resource_type         = "AWS::EC2::SecurityGroup"
  security_service_policy_data = jsonencode({
    Type = "SECURITY_GROUPS"
    ManagedServiceData = jsonencode({
      type = "SECURITY_GROUPS"
      securityGroups = [
        {
          id = "sg-security-scanners"  # Security group for scanners
          rules = [
            {
              # Allow inbound traffic from security scanners
              type = "INGRESS"
              protocol = "-1"  # All protocols
              fromPort = 0
              toPort = 65535
              source = "10.0.0.0/8"  # Internal network range for scanners
              description = "Allow all traffic from security scanners"
            },
            {
              # Allow outbound traffic to security scanners
              type = "EGRESS"
              protocol = "-1"
              fromPort = 0
              toPort = 65535
              destination = "10.0.0.0/8"
              description = "Allow all traffic to security scanners"
            }
          ]
        }
      ]
    })
  })

  tags = local.common_tags
}

# Security Group for Scanners
resource "aws_security_group" "security_scanners" {
  name        = "security-scanners"
  description = "Security group for managed security scanners"
  vpc_id      = var.vpc_id

  tags = local.common_tags
}

# Allow all inbound traffic from scanners
resource "aws_security_group_rule" "scanner_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]  # Internal network range for scanners
  security_group_id = aws_security_group.security_scanners.id
  description       = "Allow all inbound traffic from security scanners"
}

# Allow all outbound traffic to scanners
resource "aws_security_group_rule" "scanner_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]  # Internal network range for scanners
  security_group_id = aws_security_group.security_scanners.id
  description       = "Allow all outbound traffic to security scanners"
} 