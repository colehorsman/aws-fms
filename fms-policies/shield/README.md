# AWS Shield Configuration

This directory contains the configuration for AWS Shield protection, including both Standard and Advanced protection options.

## Features

- Shield Standard and Advanced protection options
- DDoS protection for resources
- Automatic response team access configuration
- CloudWatch alarms for DDoS attacks
- CloudWatch dashboard for Shield metrics
- Health check integration for Advanced protection

## Protection Levels

### Shield Standard
- Basic DDoS protection
- Always-on detection and mitigation
- No additional cost
- Suitable for most applications

### Shield Advanced
- Enhanced DDoS protection
- 24/7 DDoS response team
- Cost protection
- WAF integration
- Advanced metrics and reporting
- Suitable for critical applications

## Usage

1. Configure the required variables in your `terraform.tfvars` file:

```hcl
environment    = "prod"
resource_arn   = "arn:aws:elasticloadbalancing:region:account:loadbalancer/app/name/1234567890"
shield_standard_enabled = true
shield_advanced_enabled = true
health_check_arn = "arn:aws:route53:::healthcheck/1234567890"
sns_topic_arn  = "arn:aws:sns:region:account-id:topic-name"
tags = {
  Environment = "prod"
  Project     = "security"
}
```

2. Apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Monitoring

### CloudWatch Alarms
- DDoS attack detection
- Attack metrics monitoring
- Automatic notifications via SNS

### CloudWatch Dashboard
- Real-time DDoS metrics
- Attack patterns visualization
- Historical attack data

## Best Practices

1. **Resource Selection**
   - Enable Shield Standard for all public-facing resources
   - Use Shield Advanced for critical applications
   - Consider cost vs. protection level

2. **Health Checks**
   - Configure health checks for Shield Advanced
   - Use appropriate health check settings
   - Monitor health check status

3. **Response Team Access**
   - Configure DRT access role
   - Review and update permissions regularly
   - Test access periodically

4. **Cost Management**
   - Monitor Shield Advanced costs
   - Use cost protection features
   - Review protection levels regularly

5. **Integration**
   - Integrate with WAF for enhanced protection
   - Use with Route53 for DNS protection
   - Combine with other security services

## Security Considerations

- Regularly review Shield configurations
- Monitor for false positives
- Update protection settings based on threats
- Maintain response team contact information
- Document incident response procedures 